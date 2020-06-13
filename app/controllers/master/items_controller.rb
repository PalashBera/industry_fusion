class Master::ItemsController < Master::HomeController
  include ChangeLogable
  include Exportable

  def index
    @search = Item.ransack(params[:q])
    @search.sorts = "name asc" if @search.sorts.empty?
    @pagy, @items = pagy(@search.result.included_resources, items: 20)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      redirect_to master_items_path, flash: { success: t("flash_messages.created", name: "Item") }
    else
      render "new"
    end
  end

  def edit
    item
  end

  def update
    if item.update(item_params)
      redirect_to master_items_path, flash: { success: t("flash_messages.updated", name: "Item") }
    else
      render "edit"
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :archive, :uom_id, :item_group_id, :secondary_uom_id, :primary_quantity, :secondary_quantity)
  end

  def item
    @item ||= Item.find(params[:id])
  end
end
