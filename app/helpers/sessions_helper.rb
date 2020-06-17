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

  def accessible_warehouse_ids
    if admin_user_signed_in?
      @accessible_warehouse_ids ||= Warehouse.all.pluck(:id)
    else
      @accessible_warehouse_ids ||= current_user.warehouse_ids.map(&:to_i)
    end
  end
end
