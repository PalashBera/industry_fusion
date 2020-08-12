require "auth"

class Procurement::ApprovalRequests::EmailApprovalsController < Procurement::ApprovalRequests::HomeController
  layout "basic"

  skip_before_action :authenticate_user!

  def show
    if auth_verified?
      @message = @approval_request_user.approve
    else
      @message = "Opps! Invaid access. Please try again using application."
    end
  end

  private

  def auth_verified?
    auth = Auth.decode(params[:id])
    @approval_request_user = ApprovalRequestUser.find_by(id: auth.first["approval_request_user"])
  end
end
