class ApplicationController < ActionController::Base
  protect_from_forgery

  include Pagy::Backend
  include SessionsHelper

  layout :resolve_layout

  set_current_tenant_through_filter

  before_action :find_and_set_current_tenant
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit
  before_action :set_current_user, :set_current_organization
  before_action :remove_empty_parameters, only: :index

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:alert] = "Access denied. You are not authorized to access the requested page."
    redirect_to(dashboard_path)
  end

  protected

  def find_and_set_current_tenant
    set_current_tenant(current_organization)
  end

  def user_for_paper_trail
    current_user&.full_name || "Public User"
  end

  def check_organization_presence
    return true if current_organization

    flash[:error] = "Please register your organization."
    redirect_to new_organization_path
  end

  def authenticate_admin
    return if admin_user_signed_in?

    flash[:error] = "You don't have access."
    redirect_to dashboard_path
  end

  def permission
    name.gsub("Controller", "").singularize.split("::").last.constantize.name
  rescue StandardError
    nil
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name mobile_number])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name mobile_number])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[first_name last_name mobile_number])
  end

  def after_sign_in_path_for(resource)
    if current_organization.nil?
      flash[:error] = "Please register your organization."
      new_organization_path
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
    else
      "basic"
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  # load the permissions for the current user so that UI can be manipulated
  def load_permissions
    @current_permissions = current_user.role.permissions.map { |i| [i.subject_class, i.action] }
  end
end
