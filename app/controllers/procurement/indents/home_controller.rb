require "auth"

class Procurement::Indents::HomeController < Procurement::HomeController
  layout "print", only: :print

  before_action { active_sidebar_option("indents") }
  skip_before_action :authenticate_user!, only: %i[email_approval email_rejection]

  protected

  def index
    @search = IndentItem.joins(:indent).ransack(params[:q])
    indent_items = @search.result.public_send(scope_method)
    @total_count = indent_items.count
    @bordered_item_ids = indent_items.group_by(&:indent_id).map { |_k, v| v.last.id }
    @pagy, @indent_items = pagy_countless(indent_items.included_resources, link_extra: 'data-remote="true"')
  end

  def show
    indent
    render "procurement/shared/show"
  end

  def new
    @indent = Indent.new
    @indent_item = @indent.indent_items.build
  end

  def create
    @indent = Indent.new(indent_params)

    if @indent.save
      redirect_to redirect_path, flash: { success: t("flash_messages.created", name: "Indent") }
    else
      render "new"
    end
  end

  def edit
    indent
  end

  def update
    if indent.update(indent_params)
      redirect_to redirect_path, flash: { success: t("flash_messages.updated", name: "Indent") }
    else
      render "edit"
    end
  end

  def destroy
    indent_item = IndentItem.find(params[:id])
    indent_item.public_send(delete_method)
    redirect_to redirect_path, flash: { success: destroy_flash_message }
  end

  def print
    indent
    render "procurement/shared/print"
  end

  def send_for_approval
    item = IndentItem.find(params[:id])
    item.create_approvals && item.send_for_approval
    redirect_to redirect_path, flash: { success: t("flash_messages.created", name: "Approval request") }
  end

  def indent
    @indent ||= Indent.find(params[:id])
  end

  def indent_params
    params.require(:indent).permit(:requirement_date, :company_id, :warehouse_id, :indentor_id,
                                   indent_items_attributes: %i[id item_id cost_center_id make_id uom_id quantity priority note _destroy])
  end

  def redirect_path
    raise NotImplementedError
  end

  def scope_method
    raise NotImplementedError
  end

  def delete_method
    raise NotImplementedError
  end

  def destroy_flash_message
    raise NotImplementedError
  end
end