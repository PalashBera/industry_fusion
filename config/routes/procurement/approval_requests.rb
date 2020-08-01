Rails.application.routes.draw do
  constraints SubdomainRouter::Constraint do
    namespace :procurement do
      namespace :approval_requests do
        resources :indents, only: [:index, :update]
        resources :email_approvals, only: :show
        resources :email_rejections, only: :show
      end
    end
  end
end
