class Master::WarehouseLocationsController < Master::HomeController
  include ChangeLogable
  include Exportable

  def index
    @search = WarehouseLocation.ransack(params[:q])
    @search.sorts = "name asc" if @search.sorts.empty?
    @pagy, @warehouse_locations = pagy(@search.result.included_resources, items: 20)
  end

  def new
    @warehouse_location = WarehouseLocation.new
  end

  def create
    @warehouse_location = WarehouseLocation.new(warehouse_location_params)

    if @warehouse_location.save
      redirect_to master_warehouse_locations_path, flash: { success: t("flash_messages.created", name: "Location") }
    else
      render "new"
    end
  end

  def edit
    warehouse_location
  end

  def update
    if warehouse_location.update(warehouse_location_params)
      redirect_to master_warehouse_locations_path, flash: { success: t("flash_messages.updated", name: "Location") }
    else
      render "edit"
    end
  end

  private

  def warehouse_location_params
    params.require(:warehouse_location).permit(:name, :archive, :warehouse_id)
  end

  def warehouse_location
    @warehouse_location ||= WarehouseLocation.find(params[:id])
  end
end
