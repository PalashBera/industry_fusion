class Admin::UsersController < Admin::AdminController
  include Exportable

  def index
    @search = current_organization.users.ransack(params[:q])
    @search.sorts = "first_name desc" if @search.sorts.empty?
    @pagy, @users = pagy(@search.result, items: 20)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if new_user?
      User.invite!({ email: user_params[:email], organization_id: current_organization.id }, current_user).deliver_invitation
      redirect_to admin_users_path, flash: { success: "User will receive invitation mail shortly." }
    else
      @user.errors.add(:email, " is already registered in Industry Fusion")
      render "new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def new_user?
    return false if User.find_by(email: user_params[:email]).present?

    true
  end
end
