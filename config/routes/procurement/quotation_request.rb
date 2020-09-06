Rails.application.routes.draw do
  namespace :procurement do
    resources :quotation_requests
  end
end
