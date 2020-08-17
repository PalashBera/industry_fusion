class Procurement::Reports::IndentsController < Procurement::HomeController
  before_action { active_sidebar_option("reports") }

  def index
    @item_names, @item_wise_indent_items = Indent.indent_item_vs_item
    @cost_center_names, @cost_center_wise_indent_items = Indent.indent_item_vs_cost_center
  end
end
