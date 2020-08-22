class Master::PaymentTermsController < Master::HomeController
  include ChangeLogable
  include Exportable
  include Importable

  def index
    @search = PaymentTerm.ransack(params[:q])
    @search.sorts = "name asc" if @search.sorts.empty?
    @pagy, @payment_terms = pagy(@search.result, items: 20)
  end

  def new
    @payment_term = PaymentTerm.new
  end

  def create
    @payment_term = PaymentTerm.new(payment_term_params)

    if @payment_term.save
      redirect_to master_payment_terms_path, flash: { success: t("flash_messages.created", name: "Payment term") }
    else
      render "new"
    end
  end

  def edit
    payment_term
  end

  def update
    if payment_term.update(payment_term_params)
      redirect_to master_payment_terms_path, flash: { success: t("flash_messages.updated", name: "Payment term") }
    else
      render "edit"
    end
  end

  private

  def payment_term_params
    params.require(:payment_term).permit(:name, :description, :archive)
  end

  def payment_term
    @payment_term ||= PaymentTerm.find(params[:id])
  end
end
