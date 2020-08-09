class Procurement::Indents::AmendedIndentsController < Procurement::Indents::HomeController
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

  def export
    super
  end

  private

  def redirect_path
    procurement_amended_indents_path
  end

  def scope_method
    "amended"
  end

  def delete_method
    "mark_as_approved"
  end

  def destroy_flash_message
    t("flash_messages.restored", name: "Indent")
  end
end
