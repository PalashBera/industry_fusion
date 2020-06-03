class HomeController < ApplicationController
  before_action :authenticate_session!, only: :dashboard

  def index; end

  def dashboard
    if current_vendor
      vendor_dashboard
    elsif current_user.admin?
      admin_dashboard
    else
      user_dashboard
    end
  end

  def mark_all_read
    current_user.user_notifications.update_all(read: Time.zone.now)
  end

  def mark_read
    @user_notification = UserNotification.find(params[:id])
    @user_notification.update_column(:read, Time.zone.now)
  end

  private

  def admin_dashboard
    render "dashboards/admin"
  end

  def user_dashboard
    render "dashboards/user"
  end

  def vendor_dashboard
    render "dashboards/vendor"
  end
end
