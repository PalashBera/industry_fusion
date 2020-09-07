Rails.application.routes.draw do
  namespace :procurement do
    resources :indents do
      member do
        get :print
        put :restore
        put :cancel
        put :amend
        put :send_for_approval
      end

      get :export, on: :collection
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
end
