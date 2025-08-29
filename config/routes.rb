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
    post   'admins',         to: 'users/registrations#create_admin', as: :admin_registration

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

    get  'super_admins/sign_in',  to: 'users/sessions#new_super_admin',  as: :new_super_admin_session
    post 'super_admins/sign_in',  to: 'users/sessions#create_super_admin'
  end

  # Dashboards (next step)
  get 'teacher/home', to: 'teachers#home', as: :teacher_home
  get 'student/home', to: 'students#home', as: :student_home
  get 'student/courses', to: 'students#courses', as: :students_courses
  get 'student/assignments', to: 'students#assignments', as: :students_assignments
  get 'admin/home', to: 'admins#home', as: :admin_home
  get 'super_admin/home', to: 'super_admins#home', as: :super_admin_home

  resources :schools
  
  # Top-level assignments index for teachers/admins
  resources :assignments, only: [:index]

  get  'admins/import_teachers', to: 'admins#import_teachers_form', as: :admins_import_teachers_form
  post 'admins/import_teachers', to: 'admins#import_teachers', as: :admins_import_teachers
 
  get  'admins/import_students', to: 'admins#import_students_form', as: :admins_import_students_form
  post 'admins/import_students', to: 'admins#import_students', as: :admins_import_students

  resources :courses do
    member do
      get 'invite_students'
      patch 'add_students'
      delete 'remove_student/:student_id', to: 'courses#remove_student', as: 'remove_student'
    end
    resources :groups do
        member do
          post :add_student
          delete :remove_student
        end
      end
    resources :assignments do
      member do
        get :success
        # get 'view_marks' # Creates assignment_view_marks_path(@assignment, group_id: group.id)
      end
    end
  end

  # Student peer marking flow
  get  'student/courses/:course_id/assignments/:assignment_id/marking', to: 'student_peer_marks#edit',   as: :student_peer_marking
  patch 'student/courses/:course_id/assignments/:assignment_id/marking', to: 'student_peer_marks#update', as: :update_student_peer_marking
  post 'student/courses/:course_id/assignments/:assignment_id/submit',   to: 'student_peer_marks#submit', as: :submit_student_peer_marking
  get  'student/courses/:course_id/assignments/:assignment_id/summary',  to: 'student_peer_marks#summary', as: :student_peer_mark_summary

  # Assignment creation wizard routes
  get 'assignments/new_wizard', to: 'assignments#new_wizard', as: :new_assignment_wizard
  get 'assignments/select_course', to: 'assignments#select_course', as: :select_assignment_course
  get 'assignments/select_type', to: 'assignments#select_type', as: :select_assignment_type
  get "assignments/:assignment_id/groups/:id/view_marks", to: "assignments#view_marks", as: :assignment_view_marks

end
