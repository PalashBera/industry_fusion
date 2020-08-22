class Master::AdditionalTermsController < Master::HomeController
  include ChangeLogable

  def index
    @search = AdditionalTerm.ransack(params[:q])
    @search.sorts = "name asc" if @search.sorts.empty?
    @pagy, @additional_terms = pagy(@search.result(distinct: true), items: 20)
  end

  def show
    additional_term
  end

  def new
    @additional_term = AdditionalTerm.new
  end

  def create
    @additional_term = AdditionalTerm.new(additional_term_params)

    if @additional_term.save
      redirect_to master_additional_terms_path, flash: { success: t("flash_messages.created", name: "Additional term") }
    else
      render "new"
    end
  end

  def edit
    additional_term
  end

  def update
    if additional_term.update(additional_term_params)
      redirect_to master_additional_terms_path, flash: { success: t("flash_messages.updated", name: "Additional term") }
    else
      render "edit"
    end
  end

  private

  def additional_term_params
    params.require(:additional_term).permit(:name, :archive, :conditions)
  end

  def additional_term
    @additional_term ||= AdditionalTerm.find(params[:id])
  end
end
