class Transactions::Indents::ApprovedIndentsController < Transactions::HomeController
  def index
    @search = IndentItem.joins(:indent).ransack(params[:q])
    indent_items = @search.result.filter_by_approved
    @bordered_item_ids = indent_items.group_by(&:indent_id).map { |_k, v| v.last.id }
    @pagy, @indent_items = pagy_countless(indent_items.included_resources, link_extra: 'data-remote="true"') # have to sort by indent serial with respect to FY
  end

  def show
    @indent = Indent.find(params[:id])
  end
end
