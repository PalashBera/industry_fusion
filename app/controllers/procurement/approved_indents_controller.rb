class Procurement::ApprovedIndentsController < Procurement::IndentsController
  def index
    super
  end

  def show
    super
  end

  def destroy
    indent_item = IndentItem.find(params[:id])
    indent_item.mark_as_amended
    redirect_to procurement_approved_indents_path, flash: { success: t("flash_messages.amended", name: "Item item") }
  end

  def print
    super
  end

  private

  def indent
    super
  end

  def scope_method
    "approved"
  end
end
