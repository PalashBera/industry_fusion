class Master::UomsController < Master::MasterController
  include ChangeLogable
  include Exportable

  def index
    @search = Uom.ransack(params[:q])
    @filter_active = true if params[:q].present?
    @search.sorts = "name asc" if @search.sorts.empty?
    @pagy, @uoms = pagy(@search.result(distinct: true), items: 20)
  end

  def new
    @uom = Uom.new
  end

  def create
    @uom = Uom.new(uom_params)

    if @uom.save
      redirect_to master_uoms_path, flash: { success: "Uom has been successfully created." }
    else
      render "new"
    end
  end

  def edit
    uom
  end

  def update
    if uom.update(uom_params)
      redirect_to master_uoms_path, flash: { success: "Uom has been successfully updated." }
    else
      render "edit"
    end
  end

  private

  def uom_params
    params.require(:uom).permit(:name, :archive)
  end

  def uom
    @uom ||= Uom.find(params[:id])
  end
end
