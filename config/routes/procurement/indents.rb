Rails.application.routes.draw do
  constraints SubdomainRouter::Constraint do
    namespace :procurement do
      resources :pending_indents, path: "indents/pending", controller: "indents/pending_indents" do
        member do
          get :print
          get :send_for_approval
        end
      end

      resources :approved_indents, only: %i[index show destroy], path: "indents/approved", controller: "indents/approved_indents" do
        get :print, on: :member
      end

      resources :rejected_indents, except: %i[new create destroy], path: "indents/rejected", controller: "indents/rejected_indents" do
        member do
          get :print
          get :send_for_approval
        end
      end

      resources :amended_indents, only: %i[index show destroy], path: "indents/amended", controller: "indents/amended_indents" do
        get :print, on: :member
      end

      resources :cancelled_indents, only: %i[index show destroy], path: "indents/cancelled", controller: "indents/cancelled_indents" do
        get :print, on: :member
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
end
