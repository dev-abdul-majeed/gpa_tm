class Users::RegistrationsController < Devise::RegistrationsController
    def new_teacher
      build_resource({})
      resource.type = 'Teacher'
      respond_with resource
    end
  
    def create_teacher
      
      build_resource(sign_up_params.merge(type: 'Teacher'))
      resource.save
      yield resource if block_given?
      if resource.persisted?
        # if resource.active_for_authentication?
          sign_up(resource_name, resource)
          redirect_to teacher_home_path
          # else
          # expire_data_after_sign_in!
          # redirect_to after_inactive_sign_up_path_for(resource)
        # end
      else
        clean_up_passwords resource
        render :new_teacher, status: :unprocessable_entity
      end
    end
  
    def new_student
      build_resource({})
      resource.type = 'Student'
      respond_with resource, location: after_sign_up_path_for(resource)
    end
  
    def create_student
      build_resource(sign_up_params.merge(type: 'Student'))
      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          sign_up(resource_name, resource)
          redirect_to after_sign_up_path_for(resource)
        else
          expire_data_after_sign_in!
          redirect_to after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        render :new_student, status: :unprocessable_entity
      end
    end
  
    private
  
    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :gender, :date_of_birth)
    end
  end
  