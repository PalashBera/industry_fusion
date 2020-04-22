class Transactions::IndentsController < Transactions::TransactionsController
  def index; end

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
