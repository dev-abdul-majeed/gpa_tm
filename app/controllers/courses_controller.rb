class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_teacher
  before_action :set_course, only: [:show, :edit, :update, :destroy, :invite_students, :add_students]
  
  def index
    @courses = current_user.courses.includes(:students)
  end
  
  def show
  end
  
  def new
    @course = current_user.courses.build
  end
  
  def create
    @course = current_user.courses.build(course_params)
    
    if @course.save
      redirect_to courses_path, notice: 'Course successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @course.update(course_params)
      redirect_to courses_path, notice: 'Course successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @course.destroy
    redirect_to courses_url, notice: 'Course successfully deleted.'
  end

  def invite_students
    @available_students = Student.where.not(id: @course.student_ids)
  end

  def add_students
    if params[:course][:student_ids].present?
      student_ids = params[:course][:student_ids].reject(&:blank?)
      @course.student_ids += student_ids.map(&:to_i)
      redirect_to courses_path, notice: "#{student_ids.count} students added to #{@course.name}"
    else
      redirect_to invite_students_course_path(@course), alert: "Please select at least one student"
    end
  end

  
  private
  
  def set_course
    @course = current_user.courses.find(params[:id])
  end
  
  def course_params
    params.require(:course).permit(:name, :description, student_ids: [])
  end
  
  def ensure_teacher
    redirect_to root_path unless current_user.teacher?
  end
end