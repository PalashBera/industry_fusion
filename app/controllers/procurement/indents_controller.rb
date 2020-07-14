require "auth"

class Procurement::IndentsController < Procurement::HomeController
  layout "print", only: :print

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

  def edit
    indent
  end

  def update
    if indent.update(indent_params)
      flash[:success] = t("flash_messages.updated", name: "Indent")
      redirect
    else
      render "edit"
    end
  end

  def print
    indent
    render "procurement/shared/print"
  end

  def send_for_approval
    item = IndentItem.find(params[:id])
    item.create_approvals && item.send_for_approval
    flash[:success] = t("flash_messages.created", name: "Approval request")
    redirect
  end

  def indent
    @indent ||= Indent.find(params[:id])
  end

  def indent_params
    params.require(:indent).permit(:requirement_date, :company_id, :warehouse_id, :indentor_id,
                                   indent_items_attributes: %i[id item_id cost_center_id make_id uom_id quantity priority note _destroy])
  end

  def redirect
    raise NotImplementedError
  end

  def scope_method
    raise NotImplementedError
  end
end
