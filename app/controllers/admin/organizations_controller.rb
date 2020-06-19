class Admin::OrganizationsController < Admin::HomeController
  def edit
    @organization = current_organization
  end

  def update
    @organization = current_organization

    if @organization.update(organization_params)
      redirect_to edit_admin_organization_path(current_organization), flash: { success: "Organization has been successfully updated." }
    else
      render "edit"
    end
  end

  def preferences
    @organization = current_organization
    return unless params[:organization].present?

    if @organization.update(organization_preference_params)
      redirect_to preferences_admin_organizations_path, flash: { success: t("flash_messages.updated", name: "Organization preference") }
    else
      render "preferences"
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :address1, :address2, :city, :state, :country, :pin_code, :phone_number, :fy_start_month, :fy_end_month)
  end

  def organization_preference_params
    params.require(:organization).permit(:page_help_needed, :send_master_notification)
  end
end
