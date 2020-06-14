module SessionsHelper
  def admin_user_signed_in?
    current_user&.admin?
  end

  def current_organization
    @current_organization ||= current_user&.organization
  end

  def allow_organization_settings?
    current_organization && admin_user_signed_in?
  end
end
