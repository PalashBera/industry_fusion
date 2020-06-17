class Admin::UsersController < Admin::HomeController
  include ChangeLogable
  include Exportable

  def index
    @search = current_organization.users.ransack(params[:q]) # current_organization will be removed after adding act as tenant
    @search.sorts = "first_name asc" if @search.sorts.empty?
    @pagy, @users = pagy(@search.result, items: 20)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if User.exists?(user_params)
      @user.errors.add(:email, " is already taken")
      render "new"
    else
      User.invite!({ email: user_params[:email], organization_id: current_organization.id }, current_user).deliver_invitation
      redirect_to admin_users_path, flash: { success: "User will receive invitation mail shortly." }
    end
  end

  def edit
    user
  end

  def update
    if user.update(user_update_params)
      redirect_to admin_users_path, flash: { success: t("flash_messages.updated", name: "User") }
    else
      render "edit"
    end
  end

  def resend_invitation
    user = User.find(params[:id])
    User.invite!({ email: user.email, organization_id: current_organization.id }, current_user).deliver_invitation
    redirect_to admin_users_path, flash: { success: "User will receive invitation mail shortly." }
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :archive, warehouse_ids: [])
  end

  def user_update_params
    params.require(:user).permit(:archive, warehouse_ids: [])
  end
end
