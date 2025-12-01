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
  end

  private

  def ensure_student
    redirect_to root_path unless current_user&.student?
  end
end
