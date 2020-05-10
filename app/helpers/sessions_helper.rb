module SessionsHelper
  def admin_user_signed_in?
    current_user&.admin?
  end

  def current_organization
    @current_organization ||= current_user&.organization
  end

  def current_store
    @current_store ||= current_vendor&.store_information
  end
end
