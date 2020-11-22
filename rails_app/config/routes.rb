Rails.application.routes.draw do
  
  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    sessions: 'users/sessions',
  }

  resources :users, only: [:show], param: :user_id
  namespace :users do
    resource :password, only: [:edit, :update]
  end

  root "top#show"
end
