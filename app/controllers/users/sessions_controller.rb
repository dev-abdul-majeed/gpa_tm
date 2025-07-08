class Users::SessionsController < Devise::RegistrationsController
    def new_teacher
        build_resource({})
        respond_with resource, location: after_sign_in_path_for(resource)
    end
    
    def create_teacher
        user = User.find_by(email: params[:user][:email])
    
        if user&.valid_password?(params[:user][:password]) && user.is_a?(Teacher)
          sign_in(:user, user)
          redirect_to teacher_home_path
        else
          flash.now[:alert] = "Invalid teacher credentials"
          render :new_teacher, status: :unprocessable_entity
        end
    end
    
    def new_student
        build_resource({})
        respond_with resource, location: after_sign_in_path_for(resource)
    end
    
    def create_student
        user = User.find_by(email: params[:user][:email])
    
        if user&.valid_password?(params[:user][:password]) && user.is_a?(Student)
          sign_in(:user, user)
          redirect_to student_home_path
        else
          flash.now[:alert] = "Invalid student credentials"
          render :new_student, status: :unprocessable_entity
        end
    end
    
    def new_admin
        build_resource({})
        respond_with resource, location: after_sign_in_path_for(resource)
    end
    
    def create_admin
        user = User.find_by(email: params[:user][:email])
    
        if user&.valid_password?(params[:user][:password]) && user.is_a?(Admin)
          sign_in(:user, user)
          redirect_to admin_home_path
        else
          flash.now[:alert] = "Invalid admin credentials"
          render :new_admin, status: :unprocessable_entity
        end
    end

end