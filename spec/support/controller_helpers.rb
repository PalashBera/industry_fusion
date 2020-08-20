module ControllerHelpers
  def sign_in(user = FactoryBot.create(:user))
    if user.nil?
      request.env["warden"].stub(:authenticate!).and_throw(:warden, { scope: :user })
      controller.stub(:current_user).and_return(nil)
      ActsAsTenant.current_tenant = nil
      User.current_user = nil
      Organization.current_organization = nil
    else
      request.env["warden"].stub(:authenticate!).and_return(user)
      controller.stub(:current_user).and_return(user)
      ActsAsTenant.current_tenant = user.organization
      User.current_user = user
      Organization.current_organization = user.organization
    end
  end
end
