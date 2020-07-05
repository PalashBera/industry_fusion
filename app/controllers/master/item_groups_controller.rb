class Master::ItemGroupsController < Master::HomeController
  include ChangeLogable
  include Exportable
  include Importable

  def index
    @search = ItemGroup.ransack(params[:q])
    @search.sorts = "name asc" if @search.sorts.empty?
    @pagy, @item_groups = pagy(@search.result(distinct: true), items: 20)
  end

  def new
    @item_group = ItemGroup.new
  end

  def create
    @item_group = ItemGroup.new(item_group_params)

    if @item_group.save
      redirect_to master_item_groups_path, flash: { success: t("flash_messages.created", name: "Item Group") }
    else
      render "new"
    end
  end

  def edit
    item_group
  end

  def update
    if item_group.update(item_group_params)
      redirect_to master_item_groups_path, flash: { success: t("flash_messages.updated", name: "Item Group") }
    else
      render "edit"
    end
  end

  private

  def item_group_params
    params.require(:item_group).permit(:name, :description, :archive, :hsn_code)
  end

  def item_group
    @item_group ||= ItemGroup.find(params[:id])
  end
end
