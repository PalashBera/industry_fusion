Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  devise_for :users, skip: [:registrations, :invitations]

  devise_scope :user do
    resource :registration,
      only: [:new, :create, :edit, :update],
      path: "users",
      path_names: { new: "sign_up" },
      controller: "devise/registrations",
      as: :user_registration

    resource :invitation,
      only: [:update,],
      path: "users/invitation",
      controller: "devise/invitations",
      as: :user_invitation do
        get "/accept", to: "devise/invitations#edit", as: :accept
      end
  end

  devise_for :vendors, skip: [:registrations, :invitations]

  devise_scope :vendor do
    resource :invitation,
      only: [:update,],
      path: "vendors/invitation",
      controller: "devise/invitations",
      as: :vendor_invitation do
        get "/accept", to: "devise/invitations#edit", as: :accept
      end
  end

  resources :organizations,      only: [:new, :create]
  resources :store_informations, only: [:new, :create]

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

    resources :makes, except: [:show, :destroy] do
      get :change_logs, on: :member
      get :export, on: :collection
    end

    resources :vendors, only: [:index, :new, :create] do
      put :resend_invitation, on: :member

      collection do
        get  :export
        post :import
      end
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

    resources :users, only: [:index, :new, :create] do
      get :export, on: :collection
      put :resend_invitation, on: :member
    end
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
  get "/dashboard", to: "home#dashboard"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
