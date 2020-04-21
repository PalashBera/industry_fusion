class Master::VendorsController < Master::MasterController
  def index
    @search = Vendor.ransack(params[:q])
    @search.sorts = "name asc" if @search.sorts.empty?
    @pagy, @vendors = pagy(@search.result, items: 20)
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(vendor_params)

    if @vendor.save
      redirect_to master_vendors_path, flash: { success: "Vendor has been successfully created." }
    else
      render "new"
    end
  end

  def edit
    vendor
  end

  def update
    if vendor.update(vendor_params)
      redirect_to master_vendors_path, flash: { success: "Vendor has been successfully updated." }
    else
      render "edit"
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :email)
  end

  def vendor
    @vendor ||= Vendor.find(params[:id])
  end
end
