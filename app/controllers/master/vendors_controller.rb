class Master::VendorsController < Master::HomeController
  def index
    @search = current_organization.vendors.ransack(params[:q])
    @search.sorts = "name asc" if @search.sorts.empty?
    @pagy, @vendors = pagy(@search.result, items: 20)
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.find_or_initialize_by(vendor_params)

    if current_organization.vendors.include?(@vendor)
      @vendor.errors.add(:email, " is already taken")
      render "new"
    else
      invite_vendor
      @vendor.organization_vendors.create(organization_id: current_organization.id)
      redirect_to master_vendors_path, flash: { success: "Vendor will receive invitation mail shortly." }
    end
  end

  def resend_invitation
    vendor = Vendor.find(params[:id])
    Vendor.invite!({ email: vendor.email }, current_vendor).deliver_invitation
    redirect_to master_vendors_path, flash: { success: "Vendor will receive invitation mail shortly." }
  end

  private

  def vendor_params
    params.require(:vendor).permit(:email)
  end

  def invite_vendor
    if @vendor.new_record?
      Vendor.invite!(vendor_params, current_user).deliver_invitation
      @vendor = Vendor.find_by(vendor_params)
    else
      @vendor.send_new_vendorship_mail
    end
  end
end
