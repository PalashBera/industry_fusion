class ApplicationController < ActionController::Base
  include SubdomainRouter::Controller
  include Pagy::Backend
  include SessionsHelper

  layout :resolve_layout

  set_current_tenant_through_filter

  before_action :find_and_set_current_tenant, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit, :set_current_user, :set_current_organization
  before_action :remove_empty_parameters, only: :index
  before_action :redirect_to_subdomain, unless: :devise_controller?

  def route_not_found
    render file: Rails.public_path.join("404.html"), status: :not_found, layout: false
  end

  def active_sidebar_option(option)
    @active_sidebar = option
  end

  protected

  def after_sign_in_path_for(resource)
    generate_stored_url(resource) || dashboard_url(subdomain: current_organization.subdomain)
  end

  def find_and_set_current_tenant
    set_current_tenant(current_organization)
  end

  def user_for_paper_trail
    current_user&.full_name || "Public User"
  end

  def authenticate_admin
    return if admin_user_signed_in?

    flash[:error] = "You don't have access."
    redirect_to dashboard_path
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name mobile_number])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name mobile_number])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[first_name last_name mobile_number])
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
    else
      "basic"
    end
  end

  def redirect_to_subdomain
    return unless current_user && request.subdomain != current_organization.subdomain

    redirect_to generate_stored_url(current_user) || dashboard_url(subdomain: current_organization.subdomain)
  end

  def generate_stored_url(resource)
    location = stored_location_for(resource)
    return if location.blank?

    "http://#{current_organization.subdomain}.#{request.domain}:#{request.port}#{location}"
  end
end
