class Procurement::AmendedIndentsController < Procurement::IndentsController
  def index
    super
  end

  def show
    super
  end

  def destroy
    indent_item = IndentItem.find(params[:id])
    indent_item.mark_as_approved
    redirect_to procurement_amended_indents_path, flash: { success: t("flash_messages.restored", name: "Item item") }
  end

  def print
    super
  end

  private

  def indent
    super
  end

  def scope_method
    "amended"
  end
end
