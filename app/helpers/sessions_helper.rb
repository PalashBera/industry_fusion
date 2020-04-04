module SessionsHelper
  def admin_user?
    current_user&.admin?
  end

  def non_admin_user?
    !admin_user?
  end
end
