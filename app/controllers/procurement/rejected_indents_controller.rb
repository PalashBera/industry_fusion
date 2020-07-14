class Procurement::RejectedIndentsController < Procurement::IndentsController
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

  def indent
    super
  end

  def indent_params
    super
  end

  def redirect
    redirect_to procurement_rejected_indents_path
  end

  def scope_method
    "rejected"
  end
end
