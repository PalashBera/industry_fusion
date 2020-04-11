class Admin::WarehousesController < Admin::AdminController
  def index
    @search = Warehouse.ransack(params[:q])
    @search.sorts = "name asc" if @search.sorts.empty?
    @pagy, @warehouses = pagy(@search.result.includes(:company), items: 20)
  end

  def new
    @warehouse = Warehouse.new
  end

  def create
    @warehouse = Warehouse.new(warehouse_params)

    if @warehouse.save
      redirect_to admin_warehouses_path, flash: { success: "Warehouse has been successfully created." }
    else
      render "new"
    end
  end

  def edit
    warehouse
  end

  def update
    if warehouse.update(warehouse_params)
      redirect_to admin_warehouses_path, flash: { success: "Warehouse has been successfully updated." }
    else
      render "edit"
    end
  end

  private

  def warehouse_params
    params.require(:warehouse).permit(:company_id, :name, :address1, :address2, :city, :state, :country, :pin_code, :phone_number, :archive)
  end

  def warehouse
    @warehouse ||= Warehouse.find(params[:id])
  end
end