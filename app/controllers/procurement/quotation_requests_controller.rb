class Procurement::QuotationRequestsController < Procurement::HomeController
  before_action :set_approved_items, :set_vendors, on: [:new, :create]

  def index
    quotation_request_items = QuotationRequestItem.all
    @total_count = quotation_request_items.count
    @pagy, @quotation_request_items = pagy_countless(quotation_request_items.included_resources, link_extra: 'data-remote="true"')
  end

  def show
    quotation_request
  end

  def edit
    head :ok
  end

  def new
    session[:quotation_request_params] = {}
    @quotation_request = QuotationRequest.new(session[:quotation_request_params])
    @quotation_request.current_step = session[:quotation_request_step] || params[:step]
  end

  def create
    session[:quotation_request_params].to_h.deep_merge!(permit_params) if params[:quotation_request]
    @quotation_request = QuotationRequest.new(session[:quotation_request_params])
    @quotation_request.current_step = session[:quotation_request_step]

    if params[:step_submit] || params[:back_button]
      if @quotation_request.valid?

        if params[:back_button]
          @quotation_request.previous_step
        elsif @quotation_request.last_step?
          @quotation_request.save if @quotation_request.all_valid?
        else
          @quotation_request.next_step
        end

        session[:quotation_request_step] = @quotation_request.current_step
      end
    end
    if @quotation_request.new_record?
      render "new"
    else
      session[:quotation_request_step] = session[:quotation_request_params] = nil
      redirect_to procurement_quotation_request_path(@quotation_request), flash: { success: t("flash_messages.created", name: "Quotation Request") }
    end
  end

  private

  def permit_params
    params.require(:quotation_request).permit(:warehouse_id, :company_id, :serial, :serial_number, vendorship_ids: [], indent_item_ids: [])
  end

  def set_approved_items
    @indent_items = IndentItem.approved.included_resources
    search_params = params[:quotation_request] && params[:quotation_request][:indent_item_ids] ? params[:q].to_unsafe_h.merge({ m: "or", id_in: params[:quotation_request][:indent_item_ids]}) : params[:q]
    @search_items = @indent_items.ransack(search_params)
    @indent_items = @search_items.result
    @bordered_item_ids = @indent_items.group_by(&:indent_id).map { |_k, v| v.last.id }
  end

  def set_vendors
    @vendors = current_organization.vendors
    search_params = params[:quotation_request] && params[:quotation_request][:vendorship_ids] ? params[:q].to_unsafe_h.merge({ m: "or", id_in: params[:quotation_request][:vendorship_ids]}) : params[:q]
    @search_vendors = @vendors.ransack(search_params)
    @vendors = @search_vendors.result
  end

  def quotation_request
    @quotation_request = QuotationRequest.find(params[:id])
  end
end
