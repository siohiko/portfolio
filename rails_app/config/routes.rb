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
  end
  
  resource :apex_profile,  except: [:show]
  
  resources :recruitings,  except: [:index] do
    collection do
      get :search, to: "recruitings#search"
    end
  end

  root "top#show"
end
