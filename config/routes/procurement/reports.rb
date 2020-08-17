Rails.application.routes.draw do
  constraints SubdomainRouter::Constraint do
    namespace :procurement do
      namespace :reports do
        resources :indents, only: :index
      end
    end
  end
end
