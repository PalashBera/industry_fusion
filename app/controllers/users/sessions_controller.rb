class Users::SessionsController < Devise::SessionsController
  def create
    user = User.find_by_email(params[:user][:email])

    if user&.archive?
      flash[:error] = "Your account has been deactivated. Please contact with your admin."
      redirect_to && (return new_user_session_url(subdomain: "app"))
    end

    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    redirect_to after_sign_in_path_for(resource)
  end

  def destroy
    Devise.sign_out_all_scopes ? signed_out = sign_out : signed_out = sign_out(resource_name)
    set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    redirect_to new_user_session_url(subdomain: "app")
  end
end
