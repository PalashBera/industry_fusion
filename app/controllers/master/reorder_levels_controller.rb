class Master::ReorderLevelsController < Master::HomeController
  include ChangeLogable
  include Exportable

  def index
    @search = ReorderLevel.ransack(params[:q])
    @search.sorts = "name asc" if @search.sorts.empty?
    @pagy, @reorder_levels = pagy(@search.result.included_resources, items: 20)
  end

  def new
    @reorder_level = ReorderLevel.new
  end

  def create
    @reorder_level = ReorderLevel.new(reorder_level_params)

    if @reorder_level.save
      redirect_to master_reorder_levels_path, flash: { success: "ReorderLevel has been successfully created." }
    else
      render "new"
    end
  end

  def edit
    reorder_level
  end

  def update
    if reorder_level.update(reorder_level_params)
      redirect_to master_reorder_levels_path, flash: { success: "ReorderLevel has been successfully updated." }
    else
      render "edit"
    end
  end

  private

  def reorder_level_params
    params.require(:reorder_level).permit(:quantity, :archive, :organization_id, :warehouse_id, :item_id, :priority)
  end

  def reorder_level
    @reorder_level ||= ReorderLevel.find(params[:id])
  end
end
