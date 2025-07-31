module ApplicationHelper
  def after_sign_in_path_for(resource)
    case resource
    when SuperAdmin
      super_admin_home_path
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

  def authenticate_user!
    unless user_signed_in?
      redirect_to root_path, alert: "You need to sign in first."
    end
  end
end
