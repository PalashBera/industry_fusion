class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit
  before_action :set_current_user

  protected

  def user_for_paper_trail
    current_user&.full_name || "Public User"
  end

  def check_organization_presence
    return if current_organization

    flash[:danger] = "You don't have any organization information. Please create your organization."
    redirect_to new_organization_path
  end

  def authenticate_admin
    return if admin_user?

    flash[:danger] = "You don't have access for this."
    redirect_to root_path
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
      flash[:danger] = "You don't have any organization information. Please create your organization."
      new_organization_path
    end
  end

  def set_current_user
    User.current_user = current_user
  end
end
