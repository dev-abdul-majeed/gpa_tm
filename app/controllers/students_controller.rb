class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_student

  def home
    @student = current_user
    @recent_courses = @student.courses.limit(5)
    @total_courses = @student.courses.count
  end

  def courses
    @student = current_user
    @courses = @student.courses.includes(:teacher, :groups)
    @grouped_courses = @courses.joins(:group_memberships).where(group_memberships: { student_id: @student.id }).distinct
    @ungrouped_courses = @courses - @grouped_courses
  end

  private

  def ensure_student
    redirect_to root_path unless current_user&.student?
  end
end
