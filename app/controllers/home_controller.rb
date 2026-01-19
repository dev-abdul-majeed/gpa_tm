class HomeController < ApplicationController
  def index
    if user_signed_in?
      case current_user
      when SuperAdmin
        redirect_to super_admin_home_path
      when Admin
        redirect_to admin_home_path
      when Teacher
        redirect_to teacher_home_path
      when Student
        redirect_to student_home_path
      else
        redirect_to root_path
      end
    end
  end
end