class Procurement::CancelledIndentsController < Procurement::IndentsController
  def index
    super
  end

  def show
    super
  end

  def destroy
    indent_item = IndentItem.find(params[:id])
    indent_item.mark_as_pending
    redirect_to procurement_cancelled_indents_path, flash: { success: t("flash_messages.restored", name: "Item item") }
  end

  def print
    super
  end

  private

  def indent
    super
  end

  def scope_method
    "cancelled"
  end
end
