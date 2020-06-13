class OrganizationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      current_user.add_organization(@organization)
      redirect_to dashboard_path, flash: { success: t("flash_messages.created", name: "Organization") }
    else
      render "new"
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :address1, :address2, :city, :state, :country, :pin_code, :phone_number, :fy_start_month, :fy_end_month)
  end
end
