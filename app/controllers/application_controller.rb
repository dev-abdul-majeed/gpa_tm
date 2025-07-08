class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    case resource
    when SuperAdmin
      superadmin_home_path
    when Admin
      admin_home_path
    when Teacher
      teacher_home_path
    when Student
      student_home_path
    else
      root_path
    end
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end
  
end
