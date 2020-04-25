class Transactions::IndentsController < Transactions::TransactionsController
  def index
    @search = IndentItem.joins(:indent).ransack(params[:q])
    # @search.sorts = "requiremet_date desc" if @search.sorts.empty?
    @pagy, @indent_items = pagy_countless(@search.result.included_resources, link_extra: 'data-remote="true"')
  end

  def new
    @indent = Indent.new
    @indent_item = @indent.indent_items.build
  end

  def create
    @indent = Indent.new(indent_params)

    if @indent.save
      redirect_to transactions_indents_path, flash: { success: "Indent has been successfully created." }
    else
      render "new"
    end
  end

  def edit; end

  def update; end

  def fetch_warehouses
    @company = Company.find(params[:company_id])
  end

  def fetch_makes_and_uoms
    item = Item.find(params[:item_id])
    @unique_id = params[:unique_id]
    @makes = item.makes.included_resources
    @uoms = item.uoms_list
  end

  private

  def indent
    @indent ||= Indent.find(params[:id])
  end

  def indent_params
    params.require(:indent).permit(:requirement_date, :company_id, :warehouse_id,
                                   indent_items_attributes: %i[id item_id cost_center_id make_id uom_id quantity priority note _destroy])
  end
end
