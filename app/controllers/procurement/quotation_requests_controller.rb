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
    @pagy, @indent_items = pagy_countless(indent_items.includes(indent_item_included_resources), link_extra: 'data-remote="true"')
    @selected_ids = session[:selected_indent_item_ids] || []
  end

  def store_indent_item
    selected_ids = session[:selected_indent_item_ids] || []
    selected_id = params[:indent_item_id]
    selected_ids.include?(selected_id) ? selected_ids.delete(selected_id) : selected_ids.push(selected_id)
    session[:selected_indent_item_ids] = selected_ids
  end

  def vendor_selection
    @search = Vendorship.ransack(params[:q])
    @pagy, @vendorships = pagy(@search.result.includes(vendorship_included_resources), link_extra: 'data-remote="true"')
    @selected_ids = session[:selected_vendorship_ids] || []
  end

  def store_vendorship
    selected_ids = session[:selected_vendorship_ids] || []
    selected_id = params[:vendorship_id]
    selected_ids.include?(selected_id) ? selected_ids.delete(selected_id) : selected_ids.push(selected_id)
    session[:selected_vendorship_ids] = selected_ids
  end

  private

  def vendorship_included_resources
    [vendor: :store_information]
  end

  def indent_item_included_resources
    [:indent, :item, { make: :brand }, :uom, :cost_center]
  end
end
