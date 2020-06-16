class Admin::RolesController < Admin::HomeController
  include Exportable

  def index
    @search = Role.ransack(params[:q])
    @search.sorts = "name asc" if @search.sorts.empty?
    @pagy, @roles = pagy(@search.result.included_resources, items: 20)
  end

  def show
    role
    @permissions = @role.permissions
  end

  def new
    @role = Role.new
    @permissions = @role.permissions
  end

  def create
    @role = Role.new(role_params)

    if @role.save
      redirect_to admin_roles_path, flash: { success: "Role has been successfully created." }
    else
      render "new"
    end
  end

  def edit
    role
    @permissions = @role.permissions
  end

  def update
    if role.update(role_params)
      redirect_to admin_roles_path, flash: { success: "Role has been successfully updated." }
    else
      render "edit"
    end
  end

  private

  def role_params
    params.require(:role).permit(:name, :archive, permission_ids: [])
  end

  def role
    @role ||= Role.find(params[:id])
  end
end
