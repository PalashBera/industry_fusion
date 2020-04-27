class Transactions::IndentsController < Transactions::HomeController
  def index
    @search = IndentItem.joins(:indent).ransack(params[:q])
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

  def edit
    indent
  end

  def update
    if indent.update(indent_params)
      redirect_to transactions_indents_path, flash: { success: "Indent has been successfully updated." }
    else
      render "edit"
    end
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
