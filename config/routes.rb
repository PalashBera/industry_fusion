Rails.application.routes.draw do
  # Load all route files
  Dir[Rails.root.join("config/routes/**/*.rb")].each { |r| load(r) }

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount DelayedJobWeb, at: "/delayed_job"

  root "home#index"

  devise_for :users, skip: %i[registrations invitations sessions]
  devise_for :vendors, skip: %i[registrations invitations]

  devise_scope :user do
    resource :registration,
              only: %i[new create],
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

  devise_scope :user do
    delete "/users/sign_out", to: "users/sessions#destroy", as: :destroy_user_session
    get "/users/edit",        to: "users/registrations#edit", as: :edit_user_registration
    put "/users",             to: "users/registrations#update"
  end

  resources :organizations, only: %i[new create]

  namespace :admin do
    resources :companies, except: %i[show destroy] do
      get :change_logs, on: :member
      get :export, on: :collection
    end

    resources :warehouses, except: %i[show destroy] do
      get :change_logs, on: :member
      get :export, on: :collection
    end

    resources :users, except: %i[show destroy] do
      get :export, on: :collection

      member do
        get :change_logs
        put :resend_invitation
        get :toggle_archive
      end
    end

    resources :organizations, only: %i[edit update]

    namespace :approval_levels do
      resources :indents, except: :show
      resources :qcs, except: :show
      resources :pos, except: :show
      resources :grns, except: :show
    end
  end

  get "/dashboard",       to: "home#dashboard"
  get "/toggle_collapse", to: "home#toggle_collapse"

  match "*unmatched", to: "application#route_not_found", via: :all
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
