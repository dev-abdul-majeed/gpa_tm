class Users::RegistrationsController < Devise::RegistrationsController
  before_action :redirect_signed_in_user

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

    def create_admin
      school_id = params[:admin][:school_id]

      # Find existing admin for the school
      existing_admin = Admin.find_by(school_id: school_id)

      if existing_admin
        if existing_admin.update(sign_up_params('admin'))
          flash[:notice] = "Admin updated successfully."
          redirect_to request.referrer
        else
          flash[:alert] = existing_admin.errors.full_messages.to_sentence
          redirect_to request.referrer, status: :unprocessable_entity
        end
      else
        # Build new admin if none exists
        build_resource(sign_up_params('admin').merge(type: 'Admin'))

        if resource.save
          # Prevent sign-in if created by superadmin
          # sign_up(resource_name, resource) # optional
          flash[:notice] = "Admin created successfully."
          redirect_to request.referrer
        else
          clean_up_passwords resource
          flash[:alert] = resource.errors.full_messages.to_sentence
          redirect_to request.referrer, status: :unprocessable_entity
        end
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

    def sign_up(resource_name, resource)
      # No-op: prevents Devise from signing in the new admin automatically
    end
  
    private
  
    def sign_up_params(user_type)
      params.require(user_type.to_sym).permit(:email, :password, :password_confirmation, :first_name, :last_name, :gender, :date_of_birth, :school_id)
    end

    def redirect_signed_in_user
      if user_signed_in?
        redirect_to after_sign_in_path_for(current_user)
      end
    end

  end
  