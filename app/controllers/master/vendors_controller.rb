class Master::VendorsController < Master::HomeController
  include Exportable
  include Importable

  def index
    @search = Vendorship.joins(vendor: :store_information).ransack(params[:q])
    @pagy, @vendorships = pagy(@search.result.includes(included_resources), items: 20)
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(vendor_params)

    if current_organization.vendors.find_by(vendor_params)
      @vendor.errors.add(:email, " is already taken")
      render "new"
    else
      invite_vendor
      @vendor.vendorships.create(organization_id: current_organization.id)
      redirect_to master_vendors_path, flash: { success: "Vendor will receive invitation mail shortly." }
    end
  end

  def toggle_archive
    vendorship = Vendorship.find(params[:id])
    vendorship.toggle_archive

    if vendorship.archive?
      redirect_to master_vendors_path, flash: { danger: t("flash_messages.archived", name: "Vendor") }
    else
      redirect_to master_vendors_path, flash: { success: t("flash_messages.activated", name: "Vendor") }
    end
  end

  def resend_invitation
    vendor = Vendor.find(params[:id])
    Vendor.invite!({ email: vendor.email }, current_user).deliver_invitation
    redirect_to master_vendors_path, flash: { success: t("flash_messages.invitation_resent", name: "Vendor") }
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

  def included_resources
    [vendor: :store_information]
  end
end
