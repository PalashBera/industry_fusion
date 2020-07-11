class Procurement::CompaniesController < Procurement::HomeController
  def warehouses
    warehouses = company.warehouses.order_by_name
    render json: { warehouses: warehouses.as_json(only: %i[id name]) }
  end

  private

  def company
    @company ||= Company.find(params[:id])
  end
end
