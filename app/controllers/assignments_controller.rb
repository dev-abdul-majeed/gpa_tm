class AssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: [:new, :create, :show, :edit, :update, :destroy, :success, :view_marks]
  before_action :set_assignment, only: [:show, :edit, :update, :destroy, :success]
  before_action :ensure_teacher_or_admin

  def index
    if params[:course_id].present?
      @course = Course.find(params[:course_id])
      @assignments = @course.assignments.order(created_at: :desc)
    else
      if current_user.teacher?
        @assignments = Assignment.joins(:course)
                                  .where(courses: { teacher_id: current_user.id })
                                  .order(created_at: :desc)
      else
        @assignments = Assignment.order(created_at: :desc)
      end
    end
  end

  def show
    @course = @assignment.course
    @groups = @course.groups.includes(:students)
    
    # Optional: Get some statistics for each group
    @group_stats = {}
    @groups.each do |group|
      @group_stats[group.id] = {
        student_count: group.students.count,
        peer_marks_count: PeerMark.where(group: ).count,
        submissions_count: PeerMarkSubmission
                            .where(assignment: @assignment, giver_id: group.students.select(:id))
                            .where(submitted: true)
                            .count
      }
    end
  end

  def success
  end

  def new
    @assignment = @course.assignments.build
    @assignment.assignment_type = params[:type] if params[:type].present?
  end

  def create
    @assignment = @course.assignments.build(assignment_params)

    if @assignment.save
      redirect_to success_course_assignment_path(@course, @assignment), notice: 'Assignment was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @assignment.update(assignment_params)
      redirect_to assignments_path, notice: 'Assignment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @assignment.destroy
    redirect_to assignments_path, notice: 'Assignment was successfully deleted.'
  end

  def view_marks
    @assignment = Assignment.find_by(id: params[:assignment_id])
    @group = Group.find(params[:id])

    # Only consider students who submitted
    submitted_givers = PeerMarkSubmission
      .where(assignment: @assignment, submitted: true)
      .pluck(:giver_id)

    @students = @group.students

    # Preload all peer marks (only from submitted givers)
    @peer_marks = PeerMark
      .where(assignment: @assignment, group: @group, giver_id: submitted_givers)
      .to_a

    # Build lookup hash for fast access
    @marks_by_pair = @peer_marks.index_by { |m| [m.giver_id, m.receiver_id] }
  end

  # Wizard methods for multi-step assignment creation
  def new_wizard
    @courses = current_user.courses.order(:name)
  end

  def select_course
    @courses = current_user.courses.order(:name)
  end

  def select_type
    @course = Course.find(params[:course_id])
    @assignment_types = [
      { id: 'qass', name: 'Qass', description: 'Question and Answer Assignment System', icon: 'fas fa-question-circle' },
      { id: 'webavalia', name: 'Webavalia', description: 'Web-based Evaluation System', icon: 'fas fa-globe' }
    ]
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_assignment
    @assignment = @course.assignments.find(params[:id])
  end

  def assignment_params
    params.require(:assignment).permit(
      :title, 
      :assignment_type, 
      :rating_scale, 
      :rating_model, 
      :calibration, 
      :start_date_time, 
      :end_date_time, 
      :self_rating_weight
    )
  end

  def ensure_teacher_or_admin
    unless current_user.teacher? || current_user.admin? || current_user.super_admin?
      redirect_to root_path, alert: 'You are not authorized to manage assignments.'
    end
  end
end
