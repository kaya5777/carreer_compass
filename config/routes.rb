Rails.application.routes.draw do
  root "pages#home"

  devise_for :users

  get "dashboard" => "dashboard#show"

  namespace :preparation do
    resources :strengths_builder, only: [ :index, :show, :create ]
    resources :resume_review, only: [ :index, :show, :create ]
    resources :casual_interview_prep, only: [ :index, :show, :create ]
  end

  namespace :interview do
    resources :question_generator, only: [ :index, :show, :create ]
    resources :mock_interview, only: [ :index, :show, :create ]
    resources :compatibility_diagnosis, only: [ :index, :show, :create ]
  end

  post "ai_messages/send_message", to: "ai_messages#send_message", as: :send_message

  get "up" => "rails/health#show", as: :rails_health_check
end
