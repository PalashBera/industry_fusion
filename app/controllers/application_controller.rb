class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper

  layout :resolve_layout

  set_current_tenant_through_filter

  before_action :find_and_set_current_tenant
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit
  before_action :set_current_user, :set_current_organization
  before_action :remove_empty_parameters, only: :index

  protected

  def find_and_set_current_tenant
    set_current_tenant(current_organization)
  end

  def user_for_paper_trail
    current_user&.full_name || current_vendor&.full_name || "Public User"
  end

  def check_organization_presence
    return true if current_organization

    flash[:error] = "Please register your organization."
    redirect_to new_organization_path
  end

  def check_store_presence
    return true if current_store

    flash[:error] = "Please register your store."
    redirect_to new_store_information_path
  end

  def authenticate_admin
    return if admin_user_signed_in?

    flash[:error] = "You don't have access."
    redirect_to dashboard_path
  end

  def authenticate_resource!
    namespace = controller_path.split("/").first

    if %w[master admin transactions organizations].include?(namespace) && !vendor_signed_in?
      authenticate_user!
      check_organization_presence
    elsif ["store_informations"].include?(namespace) && !user_signed_in?
      authenticate_vendor!
      check_organization_presence
    else
      authenticate_session!
    end
  end

  def authenticate_session!
    if !user_signed_in? && !vendor_signed_in?
      flash[:error] = "Please login before access."
      redirect_to root_path
    elsif user_signed_in?
      check_organization_presence
    elsif vendor_signed_in?
      check_store_presence
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name mobile_number])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name mobile_number])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[first_name last_name mobile_number])
  end

  def after_sign_in_path_for(resource)
    if current_user && !current_organization
      flash[:error] = "Please register your organization."
      new_organization_path
    elsif current_vendor && !current_store
      flash[:error] = "Please register your store."
      new_store_information_path
    else
      stored_location_for(resource) || dashboard_path
    end
  end

  def set_current_user
    User.current_user = current_user
  end

  def set_current_organization
    Organization.current_organization = current_organization
  end

  def remove_empty_parameters
    p = proc do |*args|
      value = args.last
      value.delete_if(&p) if value.respond_to? :delete_if
      value.blank?
    end

    params.delete_if(&p)
  end

  def resolve_layout
    if user_signed_in?
      "application"
    elsif vendor_signed_in?
      "vendor"
    else
      "basic"
    end
  end
end
