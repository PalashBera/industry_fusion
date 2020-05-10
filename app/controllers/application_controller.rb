class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper

  layout :resolve_layout

  set_current_tenant_through_filter

  before_action :find_and_set_current_tenant
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit
  before_action :set_current_user
  before_action :remove_empty_parameters, only: :index

  protected

  def find_and_set_current_tenant
    set_current_tenant(current_organization)
  end

  def user_for_paper_trail
    current_user&.full_name || "Public User"
  end

  def check_organization_presence
    return if current_organization

    flash[:error] = "You don't have any organization information. Please create your organization."
    redirect_to new_organization_path
  end

  def check_store_presence
    if current_vendor.store_information.blank?
      flash[:error] = "You don't have any store information. Please create your store."
      new_store_information_path
    else
      after_sign_in_redirection
    end
  end

  def authenticate_admin
    return if admin_user?

    flash[:error] = "You don't have access for this."
    redirect_to dashboard_path
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name mobile_number organization_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name mobile_number organization_name])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[first_name last_name mobile_number])
  end

  def after_sign_in_path_for(resource)
    if resource.class.name == "Vendor"
      check_store_presence
    elsif current_organization
      stored_location_for(resource) || after_sign_in_redirection
    else
      flash[:error] = "You don't have any organization information. Please create your organization."
      new_organization_path
    end
  end

  def after_sign_in_redirection
    dashboard_path
  end

  def user_or_vendor?
    current_user || current_vendor
  end

  def set_current_user
    if current_vendor
      Vendor.current_vendor = current_vendor
    else
      User.current_user = current_user
    end
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
