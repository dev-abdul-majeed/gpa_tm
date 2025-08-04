class GroupsController < ApplicationController
  before_action :set_course
  before_action :set_group, only: [:show, :edit, :update, :destroy, :add_student, :remove_student]

  def index
    @groups = @course.groups.includes(:students)
    @available_students = @course.students_without_groups
  end

  def show
    @available_students = @course.students_without_groups
  end

  def new
    @group = @course.groups.build
    @available_students = @course.students_without_groups
  end

  def create
    @group = @course.groups.build(group_params)
    
    if @group.save
      # Add selected students to the group
      if params[:group][:student_ids].present?
        student_ids = params[:group][:student_ids].reject(&:blank?)
        students = @course.students.where(id: student_ids)
        students.each do |student|
          @group.add_student(student)
        end
      end
      
      redirect_to course_groups_path(@course), notice: 'Group was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to course_group_path(@course, @group), notice: 'Group was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy
    redirect_to course_groups_path(@course), notice: 'Group was successfully deleted.'
  end

  def add_student
    student = Student.find(params[:student_id])
    
    if @course.students.include?(student)
      @group.add_student(student)
      redirect_to course_group_path(@course, @group), notice: 'Student was successfully added to group.'
    else
      redirect_to course_group_path(@course, @group), alert: 'Student is not enrolled in this course.'
    end
  end

  def remove_student
    student = Student.find(params[:student_id])
    membership = @group.group_memberships.find_by(student: student)
    
    if membership
      membership.destroy
      redirect_to course_group_path(@course, @group), notice: 'Student was successfully removed from group.'
    else
      redirect_to course_group_path(@course, @group), alert: 'Student is not in this group.'
    end
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_group
    @group = @course.groups.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:group_name, student_ids: [])
  end
end