class Master::BrandsController < Master::HomeController
  include ChangeLogable
  include Exportable
  include Importable

  def index
    @search = Brand.ransack(params[:q])
    @search.sorts = "name asc" if @search.sorts.empty?
    @pagy, @brands = pagy(@search.result(distinct: true), items: 20)
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)

    if @brand.save
      redirect_to master_brands_path, flash: { success: t("flash_messages.created", name: "Brand") }
    else
      render "new"
    end
  end

  def edit
    brand
  end

  def update
    if brand.update(brand_params)
      redirect_to master_brands_path, flash: { success: t("flash_messages.updated", name: "Brand") }
    else
      render "edit"
    end
  end

  private

  def brand_params
    params.require(:brand).permit(:name, :archive)
  end

  def brand
    @brand ||= Brand.find(params[:id])
  end
end
