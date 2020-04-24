class Admin::UsersController < Admin::AdminController
  include Exportable

  def index
    @search = User.ransack(params[:q])
    @search.sorts = "first_name desc" if @search.sorts.empty?
    @pagy, @users = pagy(@search.result, items: 20)
  end
end
