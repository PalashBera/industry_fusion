class Admin::CompaniesController < Admin::HomeController
  include ChangeLogable
  include Exportable

  def index
    @search = Company.ransack(params[:q])
    @search.sorts = "name asc" if @search.sorts.empty?
    @pagy, @companies = pagy(@search.result(distinct: true), items: 20)
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      redirect_to admin_companies_path, flash: { success: t("flash_messages.created", name: "Company") }
    else
      render "new"
    end
  end

  def edit
    company
  end

  def update
    if company.update(company_params)
      redirect_to admin_companies_path, flash: { success: t("flash_messages.updated", name: "Company") }
    else
      render "edit"
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :short_name, :address1, :address2, :city, :state, :country, :pin_code, :phone_number, :archive)
  end

  def company
    @company ||= Company.find(params[:id])
  end
end
