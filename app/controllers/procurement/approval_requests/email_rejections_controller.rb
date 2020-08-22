require "auth"

class Procurement::ApprovalRequests::EmailRejectionsController < Procurement::ApprovalRequests::HomeController
  layout "basic"

  skip_before_action :authenticate_user!

  def show
    if auth_verified?
      @message = @approval_request_user.reject
    else
      @message = "Opps! Invaid access. Please try again using application."
    end
  end

  private

  def auth_verified?
    auth = Auth.decode(params[:token])
    @approval_request_user = ApprovalRequestUser.find_by(id: auth.first["approval_request_user"])
  end
end
