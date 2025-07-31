class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_teacher
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  
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
      redirect_to @course, notice: 'Course successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @course.update(course_params)
      redirect_to @course, notice: 'Course successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @course.destroy
    redirect_to courses_url, notice: 'Course successfully deleted.'
  end
  
  private
  
  def set_course
    @course = current_user.courses.find(params[:id])
  end
  
  def course_params
    params.require(:course).permit(:name, :description)
  end
  
  def ensure_teacher
    redirect_to root_path unless current_user.teacher?
  end
end