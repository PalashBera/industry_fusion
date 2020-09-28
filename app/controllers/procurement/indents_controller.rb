class Procurement::IndentsController < Procurement::HomeController
  layout "print", only: :print

  before_action { active_sidebar_sub_menu_option("indents") }

  def index
    @search = IndentItem.joins(:indent).ransack(params[:q])
    indent_items = @search.result.where(indents: { warehouse_id: accessible_warehouse_ids })
    @bordered_item_ids = indent_items.group_by(&:indent_id).map { |_k, v| v.last.id }
    @pagy, @indent_items = pagy_countless(indent_items.included_resources, link_extra: 'data-remote="true"')
  end

  def show
    indent
  end

  def new
    @indent = Indent.new
    @indent_item = @indent.indent_items.build
  end

  def create
    @indent = Indent.new(indent_params)

    if @indent.save
      redirect_to procurement_indents_path, flash: { success: t("flash_messages.created", name: "Indent") }
    else
      render "new"
    end
  end

  def edit
    indent
  end

  def update
    if indent.update(indent_params)
      redirect_to procurement_indents_path, flash: { success: t("flash_messages.updated", name: "Indent") }
    else
      render "edit"
    end
  end

  def cancel
    indent_item.mark_as_cancelled
    redirect_to procurement_indents_path, flash: { success: t("flash_messages.cancelled", name: "Indent") }
  end

  def amend
    indent_item.mark_as_amended
    redirect_to procurement_indents_path, flash: { success: t("flash_messages.amended", name: "Indent") }
  end

  def restore
    indent_item.mark_as_created
    redirect_to procurement_indents_path, flash: { success: t("flash_messages.restored", name: "Indent") }
  end

  def print
    indent
    render "print"
  end

  def send_for_approval
    indent_item.create_approval_requests
    indent_item.send_approval_request_mails
    indent_item.mark_as_approval_pending
    redirect_to procurement_indents_path, flash: { success: t("flash_messages.created", name: "Approval request") }
  end

  def export
    @search = IndentItem.ransack(params[:q])
    @indent_items = @search.result.included_resources

    respond_to do |format|
      format.xlsx do
        render xlsx: "export", filename: "indents_#{I18n.l(Date.today)}.xlsx", xlsx_created_at: Time.now, xlsx_author: current_user.full_name
      end
    end
  end

  def change_logs
    @resource = IndentItem.find(params[:id])
    @versions = @resource.versions.reverse
    render "shared/change_logs"
  end

  def approval_history
    @resource = IndentItem.find(params[:id])
    @approval_requests = @resource.approval_requests.order(:id).includes(:action_taken_by)
    render "shared/approval_history"
  end

  private

  def indent
    @indent ||= Indent.find(params[:id])
  end

  def indent_item
    @indent_item ||= IndentItem.find(params[:id])
  end

  def indent_params
    params.require(:indent).permit(:company_id, :warehouse_id, :indentor_id,
                                   indent_items_attributes: %i[id item_id cost_center_id make_id uom_id quantity priority requirement_date note _destroy])
  end
end
