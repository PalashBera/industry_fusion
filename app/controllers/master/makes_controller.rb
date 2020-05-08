class Master::MakesController < Master::HomeController
  include ChangeLogable
  include Exportable

  def index
    @search = Make.ransack(params[:q])
    @search.sorts = "item_name asc" if @search.sorts.empty?
    @pagy, @makes = pagy(@search.result.included_resources, makes: 20)
  end

  def new
    @make = Make.new
  end

  def create
    @make = Make.new(make_params)

    if @make.save
      redirect_to master_makes_path, flash: { success: "Make has been successfully created." }
    else
      render "new"
    end
  end

  def edit
    make
  end

  def update
    if make.update(make_params)
      redirect_to master_makes_path, flash: { success: "Make has been successfully updated." }
    else
      render "edit"
    end
  end

  private

  def make_params
    params.require(:make).permit(:item_id, :brand_id, :cat_no, :archive)
  end

  def make
    @make ||= Make.find(params[:id])
  end
end
