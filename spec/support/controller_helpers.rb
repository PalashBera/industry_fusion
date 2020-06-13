module ControllerHelpers
  def sign_in(user = FactoryBot.create(:user))
    if user.nil?
      request.env["warden"].stub(:authenticate!).and_throw(:warden, { scope: :user })
      controller.stub(:current_user).and_return(nil)
    else
      request.env["warden"].stub(:authenticate!).and_return(user)
      controller.stub(:current_user).and_return(user)
    end
  end
end
