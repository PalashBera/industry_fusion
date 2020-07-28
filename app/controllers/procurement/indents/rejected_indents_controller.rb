class Procurement::Indents::RejectedIndentsController < Procurement::Indents::HomeController
  def index
    super
  end

  def show
    super
  end

  def edit
    super
  end

  def update
    super
  end

  def print
    super
  end

  def send_for_approval
    super
  end

  private

  def redirect_path
    procurement_rejected_indents_path
  end

  def scope_method
    "rejected"
  end
end
