Rails.application.routes.draw do
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  
  # Defines the root path route ("/")
  # root "posts#index"
  
  root to: "home#index"

  devise_for :users, skip: [:registrations]

  # Allow registrations only for teachers and students
  devise_scope :user do
    get    'teachers/sign_up', to: 'users/registrations#new_teacher', as: :new_teacher_registration
    post   'teachers',         to: 'users/registrations#create_teacher', as: :teacher_registration

    get    'students/sign_up', to: 'users/registrations#new_student', as: :new_student_registration
    post   'students',         to: 'users/registrations#create_student', as: :student_registration


    get 'teachers/sign_in', to: 'users/sessions#new_teacher', as: :new_teacher_session
    post 'teachers/sign_in', to: 'users/sessions#create_teacher'

    get 'students/sign_in', to: 'users/sessions#new_student', as: :new_student_session
    post 'students/sign_in', to: 'users/sessions#create_student'

    get 'admins/sign_in', to: 'users/sessions#new_admin', as: :new_admin_session
    post 'admins/sign_in', to: 'users/sessions#create_admin'

    # delete 'logout', to: 'users/sessions#destroy', as: :destroy_user_session
  end

  # Dashboards (next step)
  get 'teacher/home', to: 'teachers#home', as: :teacher_home
  get 'student/home', to: 'students#home', as: :student_home
  get 'admin/home', to: 'admins#home', as: :admin_home

end
