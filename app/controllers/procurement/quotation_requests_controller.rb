class Procurement::QuotationRequestsController < Procurement::HomeController
  before_action { active_sidebar_sub_menu_option("quotation_requests") }

  def index
    @search = QuotationRequest.ransack(params[:q])
    @pagy, @quotation_requests = pagy_countless(@search.result, link_extra: 'data-remote="true"')
  end

  def indent_selection
    @search = IndentItem.approved.ransack(params[:q])
    indent_items = @search.result
    @bordered_item_ids = indent_items.group_by(&:indent_id).map { |_k, v| v.last.id }
    @pagy, @indent_items = pagy_countless(indent_items.included_resources, link_extra: 'data-remote="true"')
    @selected_ids = session[:selected_indent_item_ids] || []
  end

  def store_indent_item
    selected_ids = session[:selected_indent_item_ids] || []
    selected_id = params[:indent_item_id]
    selected_ids.include?(selected_id) ? selected_ids.delete(selected_id) : selected_ids.push(selected_id)
    session[:selected_indent_item_ids] = selected_ids
  end
end
