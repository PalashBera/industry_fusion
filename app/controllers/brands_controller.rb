class BrandsController < ApplicationController
  def index
    @pagy, @brands = pagy(Brand.kept.order_by_name, items: 20)
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)

    if @brand.save
      redirect_to brands_path, flash: { success: "Brand has been successfully created." }
    else
      render "new"
    end
  end

  def edit
    brand
  end

  def update
    if brand.update(brand_params)
      redirect_to brands_path, flash: { success: "Brand has been successfully updated." }
    else
      render "edit"
    end
  end

  def destroy
    brand.discard
    redirect_to brands_path, flash: { danger: "Brand has been successfully deleted." }
  end

  private

  def brand_params
    params.require(:brand).permit(:name, :archive)
  end

  def brand
    @brand ||= Brand.find(params[:id])
  end
end
