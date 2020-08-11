Rails.application.routes.draw do
  constraints SubdomainRouter::Constraint do
    namespace :procurement do
      resources :pending_rfqs, path: "rfqs/pending", controller: "rfqs/pending_rfqs"
    end
  end
end
