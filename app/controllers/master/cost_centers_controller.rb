class Master::CostCentersController < Master::MasterController
  include ChangeLogable
  include Exportable
  include Importable

  def index
    @search = CostCenter.ransack(params[:q])
    @search.sorts = "name asc" if @search.sorts.empty?
    @pagy, @cost_centers = pagy(@search.result(distinct: true), items: 20)
  end

  def new
    @cost_center = CostCenter.new
  end

  def create
    @cost_center = CostCenter.new(cost_center_params)

    if @cost_center.save
      redirect_to master_cost_centers_path, flash: { success: "Cost Center has been successfully created." }
    else
      render "new"
    end
  end

  def edit
    cost_center
  end

  def update
    if cost_center.update(cost_center_params)
      redirect_to master_cost_centers_path, flash: { success: "Cost Center has been successfully updated." }
    else
      render "edit"
    end
  end

  private

  def cost_center_params
    params.require(:cost_center).permit(:name, :description, :archive)
  end

  def cost_center
    @cost_center ||= CostCenter.find(params[:id])
  end
end
