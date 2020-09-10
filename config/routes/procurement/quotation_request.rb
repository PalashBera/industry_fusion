Rails.application.routes.draw do
  namespace :procurement do
    resources :quotation_requests do
      collection do
        get :indent_selection
        put :store_indent_item
        get :vendor_selection
        put :store_vendorship
      end
    end
  end
end
