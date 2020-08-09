class Procurement::Indents::ApprovedIndentsController < Procurement::Indents::HomeController
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

  def scope_method
    "approved"
  end

  def redirect_path
    procurement_approved_indents_path
  end

  def delete_method
    "mark_as_amended"
  end

  def destroy_flash_message
    t("flash_messages.amended", name: "Indent")
  end
end
