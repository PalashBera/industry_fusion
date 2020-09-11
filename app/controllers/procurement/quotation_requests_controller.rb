class Procurement::QuotationRequestsController < Procurement::HomeController
  before_action { active_sidebar_sub_menu_option("quotation_requests") }
  before_action :set_selected_records, only: %i[preview create]

  def index
    @search = QuotationRequest.ransack(params[:q])
    @pagy, @quotation_requests = pagy_countless(@search.result, link_extra: 'data-remote="true"')
  end

  def create
    @quotation_request = QuotationRequest.new(quotation_request_params)
    @quotation_request.warehouse_id = @indent_items.first.indent.warehouse_id
    @quotation_request.company_id = @indent_items.first.indent.company_id

    if @quotation_request.save
      @quotation_request.create_quotation_request_items(@indent_items)
      @quotation_request.create_quotation_request_vendors(@vendorships)
      redirect_to procurement_quotation_requests_path, flash: { success: t("flash_messages.created", name: "Quotation request") }
    else
      render "preview"
    end
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

  def preview
    @quotation_request = QuotationRequest.new
  end

  private

  def quotation_request_params
    params.require(:quotation_request).permit(:note)
  end

  def set_selected_records
    selected_indent_item_ids = session[:selected_indent_item_ids]
    selected_vendorship_ids = session[:selected_vendorship_ids]

    if selected_indent_item_ids.blank?
      redirect_to indent_selection_new_procurement_quotation_request_path, flash: { danger: t("quotation_request.no_indent_selection") }
    elsif selected_vendorship_ids.blank?
      redirect_to vendor_selection_new_procurement_quotation_request_path, flash: { danger: t("quotation_request.no_vendorship_selection") }
    else
      @indent_items = IndentItem.where(id: selected_indent_item_ids).includes(indent_item_included_resources)
      @vendorships = Vendorship.where(id: selected_vendorship_ids).includes(vendorship_included_resources)
    end
  end

  def vendorship_included_resources
    [vendor: :store_information]
  end

  def indent_item_included_resources
    [:indent, :item, { make: :brand }, :uom, :cost_center]
  end
end
