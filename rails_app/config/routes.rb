Rails.application.routes.draw do
  
  devise_for :users, skip: 'sessions', controllers: { 
    registrations: 'users/registrations',
  }
  devise_scope :user do
    get 'users/sign_in', to: 'users/sessions#new', as: :new_user_session
    post 'users/sign_in', to: 'users/sessions#create', as: :user_session
    get 'users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
  end

  resources :users, only: [:show], param: :user_id
  namespace :users do
    resource :password, only: [:edit, :update]
    resource :delete_form, only: [:new]
  end

  resource :applicant_entry_recruitings, only: [:create, :update, :destroy]
  resource :apex_profile,  except: [:show]

  namespace :recruitings do
    get 'search', to: 'search#show', as: :search
  end
  resources :recruitings,  except: [:index]

  root "top#show"
end
