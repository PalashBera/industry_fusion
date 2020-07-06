class Master::IndentorsController < Master::HomeController
  include ChangeLogable
  include Exportable
  include Importable

  def index
    @search = Indentor.ransack(params[:q])
    @search.sorts = "name asc" if @search.sorts.empty?
    @pagy, @indentors = pagy(@search.result, items: 20)
  end

  def new
    @indentor = Indentor.new
  end

  def create
    @indentor = Indentor.new(indentor_params)

    if @indentor.save
      redirect_to master_indentors_path, flash: { success: t("flash_messages.created", name: "Indentor") }
    else
      render "new"
    end
  end

  def edit
    indentor
  end

  def update
    if indentor.update(indentor_params)
      redirect_to master_indentors_path, flash: { success: t("flash_messages.updated", name: "Indentor") }
    else
      render "edit"
    end
  end

  private

  def indentor_params
    params.require(:indentor).permit(:name, :archive)
  end

  def indentor
    @indentor ||= Indentor.find(params[:id])
  end
end
