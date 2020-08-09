class Procurement::Indents::IndentItemsController < Procurement::HomeController
  def show
    indent_item
  end

  private

  def indent_item
    @indent_item ||= IndentItem.find(params[:id])
  end
end
