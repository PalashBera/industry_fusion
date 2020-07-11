require "auth"

class Procurement::PendingIndentsController < Procurement::HomeController
  layout "print", only: :print

  skip_before_action :authenticate_user!, only: %i[email_approval email_rejection]

  def index
    @search = IndentItem.joins(:indent).ransack(params[:q])
    indent_items = @search.result.pending
    @bordered_item_ids = indent_items.group_by(&:indent_id).map { |_k, v| v.last.id }
    @pagy, @indent_items = pagy_countless(indent_items.included_resources, link_extra: 'data-remote="true"')
  end

  def new
    @indent = Indent.new
    @indent_item = @indent.indent_items.build
  end

  def show
    indent
  end

  def create
    @indent = Indent.new(indent_params)

    if @indent.save
      redirect_to procurement_pending_indents_path, flash: { success: t("flash_messages.created", name: "Indent") }
    else
      render "new"
    end
  end

  def edit
    indent
  end

  def update
    if indent.update(indent_params)
      redirect_to procurement_pending_indents_path, flash: { success: t("flash_messages.updated", name: "Indent") }
    else
      render "edit"
    end
  end

  def print
    indent
  end

  def send_for_approval
    item = IndentItem.find(params[:id])
    item.create_approvals && item.send_for_approval
    redirect_to procurement_pending_indents_path, flash: { success: t("flash_messages.created", name: "Approval request") }
  end

  def email_approval
    auth = Auth.decode(params[:token])
    approval = Approval.find_by(id: auth.first["approval"])
    user = User.find_by(id: auth.first["user"])

    if approval && user && approval.user_ids.include?(user.id.to_s)
      @message = approval.approve(user.id)
    else
      @message = "Invaid access. Please try again using application."
    end
  end

  def email_rejection
    auth = Auth.decode(params[:token])
    approval = Approval.find_by(id: auth.first["approval"])
    user = User.find_by(id: auth.first["user"])

    if approval && user && approval.user_ids.include?(user.id.to_s)
      @message = approval.reject(user.id)
    else
      @message = "Invaid access. Please try again using application."
    end
  end

  private

  def indent
    @indent ||= Indent.find(params[:id])
  end

  def indent_params
    params.require(:indent).permit(:requirement_date, :company_id, :warehouse_id, :indentor_id,
                                   indent_items_attributes: %i[id item_id cost_center_id make_id uom_id quantity priority note _destroy])
  end
end
