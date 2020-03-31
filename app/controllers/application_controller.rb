class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name mobile_number])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name mobile_number])
  end
end
