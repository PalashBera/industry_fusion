Rails.application.routes.draw do
  namespace :procurement do
    resources :indent_items, path: "indents/indent_items", controller: "indents/indent_items", only: :show

    resources :pending_indents, path: "indents/pending", controller: "indents/pending_indents" do
      member do
        get :print
        get :send_for_approval
      end

      get :export, on: :collection
    end

    resources :approved_indents, path: "indents/approved", controller: "indents/approved_indents", only: %i[index show destroy] do
      get :print, on: :member
      get :export, on: :collection
    end

    resources :rejected_indents, path: "indents/rejected", controller: "indents/rejected_indents", except: %i[new create destroy] do
      member do
        get :print
        get :send_for_approval
      end

      get :export, on: :collection
    end

    resources :amended_indents, path: "indents/amended", controller: "indents/amended_indents", only: %i[index show destroy] do
      get :print, on: :member
      get :export, on: :collection
    end

    resources :cancelled_indents, path: "indents/cancelled", controller: "indents/cancelled_indents", only: %i[index show destroy] do
      get :print, on: :member
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
