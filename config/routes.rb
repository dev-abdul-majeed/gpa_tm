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
  get '/teachers/home' => 'teachers/home', as: :teacher_home

  devise_for :users, skip: [:registrations], controllers: {
    sessions: 'users/sessions'
  }

  # Allow registrations only for teachers and students
  devise_scope :user do
    get    'teachers/sign_up', to: 'users/registrations#new_teacher', as: :new_teacher_registration
    post   'teachers',         to: 'users/registrations#create_teacher', as: :teacher_registration

    get    'students/sign_up', to: 'users/registrations#new_student', as: :new_student_registration
    post   'students',         to: 'users/registrations#create_student', as: :student_registration

  end

end
