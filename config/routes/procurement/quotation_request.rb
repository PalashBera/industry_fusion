Rails.application.routes.draw do
  namespace :procurement do
    resources :quotation_requests do
      get :indent_selection, on: :new
      get :vendor_selection, on: :new
      get :preview,          on: :new

      collection do
        put :store_indent_item
        put :store_vendorship
      end
    end
  end
end
