class Procurement::Indents::PendingIndentsController < Procurement::Indents::HomeController
  def index
    super
  end

  def new
    super
  end

  def show
    super
  end

  def create
    super
  end

  def edit
    super
  end

  def update
    super
  end

  def destroy
    super
  end

  def print
    super
  end

  def send_for_approval
    super
  end

  def export
    super
  end

  private

  def redirect_path
    procurement_pending_indents_path
  end

  def scope_method
    "pending_indents"
  end

  def delete_method
    "mark_as_cancelled"
  end

  def destroy_flash_message
    t("flash_messages.cancelled", name: "Indent")
  end
end
