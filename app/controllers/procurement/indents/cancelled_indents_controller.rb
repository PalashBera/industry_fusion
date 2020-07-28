class Procurement::Indents::CancelledIndentsController < Procurement::Indents::HomeController
  def index
    super
  end

  def show
    super
  end

  def destroy
    super
  end

  def print
    super
  end

  private

  def scope_method
    "cancelled"
  end

  def redirect_path
    procurement_cancelled_indents_path
  end

  def delete_method
    "mark_as_pending"
  end

  def destroy_flash_message
    t("flash_messages.restored", name: "Indent")
  end
end
