module SessionsHelper
  def admin_user?
    current_user.admin?
  end

  def non_admin_user?
    !admin_user?
  end

  def current_organization
    @current_organization ||= current_user.organization
  end
end
