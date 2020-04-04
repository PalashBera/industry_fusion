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

  def after_sign_in_path_for(resource)
    if current_organization
      stored_location_for(resource) || root_path
    else
      new_organization_path
    end
  end
end
