Rails.application.routes.draw do
  namespace :procurement do
    resources :quotation_requests do
      get :indent_selection, on: :collection
      put :store_indent_item, on: :collection
    end
  end
end
