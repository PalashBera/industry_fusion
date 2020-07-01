class HomeController < ApplicationController
  before_action :authenticate_user!, only: %i[dashboard toggle_collapse]

  def index; end

  def dashboard
    if current_user.admin?
      admin_dashboard
    else
      user_dashboard
    end
  end

  def toggle_collapse
    current_user.toggle_sidebar_collapse
    @collapsed = current_user.sidebar_collapse
  end

  private

  def admin_dashboard
    render "dashboards/admin"
  end

  def user_dashboard
    render "dashboards/user"
  end
end
