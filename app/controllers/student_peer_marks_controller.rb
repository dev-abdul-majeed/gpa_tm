class StudentPeerMarksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_student
  before_action :set_course_and_assignment
  before_action :set_group_and_members
  before_action :set_submission

  def edit
    @peer_marks = load_or_build_marks
  end

  def update
    if @submission.submitted?
      redirect_to student_peer_mark_summary_path(@course, @assignment), alert: 'Your marks are already submitted and locked.' and return
    end
    ActiveRecord::Base.transaction do
      params.fetch(:peer_marks, {}).each do |receiver_id, score_params|
        score = score_params[:score].to_i
        peer_mark = PeerMark.find_or_initialize_by(assignment: @assignment, group: @group, giver: current_user, receiver_id: receiver_id)
        peer_mark.score = score
        peer_mark.save!
      end
    end
    redirect_to student_peer_marking_path(@course, @assignment), notice: 'Draft saved successfully.'
  rescue ActiveRecord::RecordInvalid => e
    @peer_marks = load_or_build_marks
    flash.now[:alert] = e.record.errors.full_messages.to_sentence
    render :edit, status: :unprocessable_entity
  end

  def submit
    ActiveRecord::Base.transaction do
      # Finalize scores from form first (without redirect)
      params.fetch(:peer_marks, {}).each do |receiver_id, score_params|
        score = score_params[:score].to_i
        peer_mark = PeerMark.find_or_initialize_by(assignment: @assignment, group: @group, giver: current_user, receiver_id: receiver_id)
        peer_mark.score = score
        peer_mark.save!
      end
      # Ensure totals and lock submission
      @submission.update!(submitted: true)
    end
    redirect_to student_peer_mark_summary_path(@course, @assignment), notice: 'Peer marks submitted successfully.'
  rescue ActiveRecord::RecordInvalid => e
    @peer_marks = load_or_build_marks
    flash.now[:alert] = e.record.errors.full_messages.to_sentence
    render :edit, status: :unprocessable_entity
  end

  def summary
    @given_marks = PeerMark.where(assignment: @assignment, giver: current_user).includes(:receiver)
  end

  private

  def ensure_student
    redirect_to root_path unless current_user&.student?
  end

  def set_course_and_assignment
    @course = Course.find(params[:course_id])
    @assignment = @course.assignments.find(params[:assignment_id])
  end

  def set_group_and_members
    @group = current_user.group_for_course(@course)
    unless @group
      redirect_to students_assignments_path, alert: 'You are not in a group for this course.' and return
    end
    @group_members = @group.students.order(:first_name, :last_name)
  end

  def set_submission
    @submission = PeerMarkSubmission.find_or_create_by!(assignment: @assignment, giver: current_user)
  end

  def load_or_build_marks
    marks = PeerMark.where(assignment: @assignment, group: @group, giver: current_user).index_by(&:receiver_id)
    @group_members.each_with_object({}) do |member, hash|
      hash[member.id] = marks[member.id] || PeerMark.new(assignment: @assignment, group: @group, giver: current_user, receiver: member, score: 0)
    end
  end
end

