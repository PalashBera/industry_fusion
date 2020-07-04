Rails.application.routes.draw do
  constraints(subdomain: SubdomainRouter::Config.default_subdomain) do
    mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

    root "home#index"

    devise_for :users, skip: [:registrations, :invitations, :sessions]
    devise_for :vendors, skip: [:registrations, :invitations]

    devise_scope :user do
      resource :registration,
        only: [:new, :create],
        path: "users",
        path_names: { new: "sign_up" },
        controller: "users/registrations",
        as: :user_registration

      get  "/users",        to: "users/registrations#users"
      get  "users/sign_in", to: "users/sessions#new", as: :new_user_session
      post "users/sign_in", to: "users/sessions#create", as: :user_session

      resource :invitation,
        only: [:update],
        path: "users/invitation",
        controller: "devise/invitations",
        as: :user_invitation do
          get "/accept", to: "devise/invitations#edit", as: :accept
        end
    end
  end

  constraints SubdomainRouter::Constraint do
    devise_scope :user do
      delete "/users/sign_out", to: "users/sessions#destroy", as: :destroy_user_session
      get "/users/edit",        to: "users/registrations#edit", as: :edit_user_registration
      put "/users",             to: "users/registrations#update"
    end

    resources :organizations, only: [:new, :create]

    namespace :master do
      resources :brands, except: [:show, :destroy] do
        get :change_logs, on: :member

        collection do
          get  :export
          post :import
        end
      end

      resources :indentors, except: [:show, :destroy] do
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

      resources :warehouse_locations, except: [:show, :destroy] do
        get :change_logs, on: :member
        get :export, on: :collection
      end

      resources :reorder_levels, except: [:show, :destroy] do
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

      resources :users, except: [:show, :destroy] do
        get :export, on: :collection

        member do
          get :change_logs
          put :resend_invitation
          get :toggle_activation
        end
      end

      resources :organizations, only: [:edit, :update]

      resources :indent_approval_levels, except: :show
      resources :qc_approval_levels,     except: :show
      resources :po_approval_levels,     except: :show
      resources :grn_approval_levels,    except: :show
    end

    namespace :transactions do
      resources :indents, except: [:destroy] do
        member do
          get :print
          get :send_for_approval
        end

        collection do
          get :email_approval
          get :email_rejection
          get :approved
        end
      end

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

    get "/dashboard",       to: "home#dashboard"
    get "/toggle_collapse", to: "home#toggle_collapse"
    get "/",                to: "home#dashboard", as: :user_root
  end

  get "/",            to: "application#route_not_found"
  match "*unmatched", to: "application#route_not_found", via: :all
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
