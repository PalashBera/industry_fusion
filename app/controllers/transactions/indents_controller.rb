class Transactions::IndentsController < Transactions::TransactionsController
  def index
    @search = IndentItem.joins(:indent).ransack(params[:q])
    # @search.sorts = "requiremet_date desc" if @search.sorts.empty?
    @pagy, @indent_items = pagy_countless(@search.result.included_resources, link_extra: 'data-remote="true"')
  end

  def new; end

  def create; end

  def edit; end

  def update; end

  private

  def indent
    @indent ||= Indent.find(params[:id])
  end

  def indent_params
    params.require(:indent).permit(:date, :company_id, :warehouse_id, indent_item_attributes: %i[id item_id cost_center_id make_id uom_id quantity priority note])
  end
end
