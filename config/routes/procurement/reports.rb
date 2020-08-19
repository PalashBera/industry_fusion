Rails.application.routes.draw do
  namespace :procurement do
    namespace :reports do
      resources :indents, only: :index
    end
  end
end
