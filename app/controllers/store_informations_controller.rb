class StoreInformationsController < ApplicationController
  before_action :authenticate_vendor!

  def new
    @store_information = StoreInformation.new
  end

  def create
    @store_information = StoreInformation.new(store_information_params)
    @store_information.vendor = current_vendor

    if @store_information.save
      redirect_to dashboard_path, flash: { success: "Store Information has been successfully created." }
    else
      render "new"
    end
  end

  private

  def store_information_params
    params.require(:store_information).permit(:name, :address1, :address2, :city, :state, :country, :pin_code, :phone_number, :pan_number, :gstn)
  end
end