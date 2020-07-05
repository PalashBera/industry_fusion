class Admin::OrganizationsController < Admin::HomeController
  def edit
    @organization = current_organization
  end

  def update
    @organization = current_organization

    if @organization.update(organization_params)
      redirect_to edit_admin_organization_path(current_organization), flash: { success: t("flash_messages.updated", name: "Organization") }
    else
      render "edit"
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :fy_start_month, :page_help_needed, :send_master_notification)
  end
end
