class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_student

  def home
    @student = current_user
    @recent_courses = @student.courses.limit(5)
    @total_courses = @student.courses.count
    @assignments_count = Assignment.where(course: @student.courses).count
    @student_assignments = Assignment.where(course: @student.courses)
                                     .includes(:course)
                                     .order(end_date_time: :asc)
                                     .limit(6)
    
    # Preload final marks for efficient checking
    assignment_ids = @student_assignments.pluck(:id)
    @final_marks_by_assignment = FinalMark.where(student: @student, assignment_id: assignment_ids)
                                           .index_by(&:assignment_id)
  end

  def view_my_marks
    @student = current_user
    @assignment = Assignment.find(params[:assignment_id])
    @final_mark = FinalMark.find_by(student: @student, assignment: @assignment)
    
    unless @final_mark
      render turbo_frame: "modal", status: :not_found, plain: "Marks not found"
      return
    end
    
    render partial: "view_my_marks_modal"
  end

  def courses
    @student = current_user
    @courses = @student.courses.includes(:teacher, :groups)
    @grouped_courses = @courses.joins(:group_memberships).where(group_memberships: { student_id: @student.id }).distinct
    @ungrouped_courses = @courses - @grouped_courses
  end

  def assignments
    @student = current_user
    @courses = @student.courses.includes(:assignments)
    @assignments_by_course = @courses.each_with_object({}) do |course, hash|
      hash[course] = course.assignments.order(start_date_time: :desc)
    end
    
    # Preload final marks for efficient checking
    all_assignment_ids = @assignments_by_course.values.flatten.map(&:id)
    @final_marks_by_assignment = FinalMark.where(student: @student, assignment_id: all_assignment_ids)
                                          .index_by(&:assignment_id)
  end

  private

  def ensure_student
    redirect_to root_path unless current_user&.student?
  end
end
