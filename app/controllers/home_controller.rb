class HomeController < ApplicationController
  before_action :authenticate_user!, :check_organization_presence, only: :dashboard

  def index; end

  def dashboard
    if current_user.admin?
      admin_dashboard
    else
      user_dashboard
    end
  end

  private

  def admin_dashboard
    render "dashboards/admin"
  end

  def user_dashboard
    render "dashboards/user"
  end
end
