class SchoolsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_super_admin!
  before_action :set_school, only: [:edit, :update, :destroy]

  def new
    @school = School.new
  end

  def create
    @school = School.new(school_params)
    if @school.save
      redirect_to super_admin_home_path, notice: "School created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @school is already set via before_action
  end

  def update
    if @school.update(school_params)
      redirect_to super_admin_home_path, notice: "School updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @school.destroy
    redirect_to super_admin_home_path, notice: "School deleted successfully."
  end

  private

  def set_school
    @school = School.find(params[:id])
  end

  def school_params
    params.require(:school).permit(:name, :location, :domain)
  end

  def require_super_admin!
    unless current_user.is_a?(SuperAdmin)
      redirect_to root_path, alert: "Access denied."
    end
  end
end
