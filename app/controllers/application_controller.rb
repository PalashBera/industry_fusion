class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit

  protected

  def user_for_paper_trail
    current_user&.full_name || "Public User"
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name mobile_number])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name mobile_number])
  end
end
