class AssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: [:new, :show, :edit, :update, :destroy]
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]
  before_action :ensure_teacher_or_admin

  def index
    @assignments = @course.assignments.order(created_at: :desc)
  end

  def show
  end

  def new
    @assignment = @course.assignments.build
    @assignment.type = params[:type] if params[:type].present?
  end

  def create
    @assignment = @course.assignments.build(assignment_params)

    if @assignment.save
      redirect_to course_assignment_path(@course, @assignment), notice: 'Assignment was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @assignment.update(assignment_params)
      redirect_to course_assignment_path(@course, @assignment), notice: 'Assignment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @assignment.destroy
    redirect_to course_assignments_path(@course), notice: 'Assignment was successfully deleted.'
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
      :type, 
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
