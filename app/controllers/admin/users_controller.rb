class Admin::UsersController < Admin::AdminController
  include Exportable

  def index
    @search = current_organization.users.ransack(params[:q])
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

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
