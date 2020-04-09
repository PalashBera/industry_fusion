class Admin::CompaniesController < Admin::AdminController
  include ChangeLogable
  include Exportable

  def index
    @search = Company.ransack(params[:q])
    @pagy, @companies = pagy(@search.result, items: 20)
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      redirect_to admin_companies_path, flash: { success: "Company has been successfully created." }
    else
      render "new"
    end
  end

  def edit
    company
  end

  def update
    if company.update(company_params)
      redirect_to admin_companies_path, flash: { success: "Company has been successfully updated." }
    else
      render "edit"
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :address1, :address2, :city, :state, :country, :pin_code, :phone_number, :archive)
  end

  def company
    @company ||= Company.find(params[:id])
  end
end
