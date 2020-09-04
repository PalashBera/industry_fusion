class Admin::UsersController < Admin::HomeController
  include ChangeLogable
  include Exportable

  def index
    @search = User.ransack(params[:q])
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
    redirect_to admin_users_path, flash: { success: t("flash_messages.invitation_resent", name: "User") }
  end

  def toggle_archive
    user.toggle_archive

    if user.archive?
      redirect_to admin_users_path, flash: { danger: t("flash_messages.archived", name: "User") }
    else
      redirect_to admin_users_path, flash: { success: t("flash_messages.activated", name: "User") }
    end
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end

  def user_update_params
    params.require(:user).permit(warehouse_ids: [])
  end
end
