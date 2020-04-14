class OrganizationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      current_user.add_organization(@organization)
      redirect_to admin_root_path, flash: { success: "Organization has been successfully created." }
    else
      render "new"
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :address1, :address2, :city, :state, :country, :pin_code, :phone_number)
  end
end
