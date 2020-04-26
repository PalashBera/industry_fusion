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

      collection do
        get  :export
        post :import
      end
    end

    resources :item_groups, except: [:show, :destroy] do
      get :change_logs, on: :member

      collection do
        get  :export
        post :import
      end
    end

    resources :cost_centers, except: [:show, :destroy] do
      get :change_logs, on: :member

      collection do
        get  :export
        post :import
      end
    end

    resources :items, except: [:show, :destroy] do
      get :change_logs, on: :member
      get :export, on: :collection
    end

    resources :vendors, except: [:show, :destroy]
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

    resources :users, only: [:index, :new, :create] do
      get :export, on: :collection
      put :resend_invitation, on: :member
    end

    root "admin#index"
  end

  namespace :transactions do
    resources :indents, except: [:show, :destroy]

    resources :companies, only: [] do
      get :warehouses, on: :member
    end

    resources :items, only: [] do
      member do
        get :makes
        get :uoms
      end
    end
  end

  root "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
