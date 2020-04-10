Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  devise_for :users

  resources :organizations, only: [:new, :create]

  namespace :master do
    resources :brands, except: [:show, :destroy] do
      get :change_logs, on: :member

      collection do
        get  :export
        post :import
      end
    end

    resources :uoms, except: [:show, :destroy] do
      get :change_logs, on: :member
      get :export, on: :collection
    end
  end

  namespace :admin do
    resources :companies, except: [:show, :destroy] do
      get :change_logs, on: :member
      get :export, on: :collection
    end

    resources :warehouses, except: [:show, :destroy] do
      get :change_logs, on: :member
      get :export, on: :collection
    end

    root "admin#index"
  end

  root "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
