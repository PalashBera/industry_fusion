Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  devise_for :users

  resources :brands, except: [:show] do
    get :change_logs, on: :member
  end

  resources :organizations, only: [:new, :create]

  root "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
