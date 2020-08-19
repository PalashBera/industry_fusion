class Users::RegistrationsController < Devise::RegistrationsController
  def create
    @user = build_and_validate_user

    if @user.errors.blank?
      organization = Organization.create(organization_params)
      @user.organization_id = organization.id
      @user.save(validate: false) && update_user_tracker(organization)
      redirect_using_devise
    else
      clean_up_passwords(@user) && set_minimum_password_length
      respond_with(@user)
    end
  end

  def users
    redirect_to new_user_registration_path
  end

  protected

  def after_update_path_for(_resource)
    edit_user_registration_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :mobile_number, :email, :password, :password_confirmation, :name, :fy_start_month)
  end

  def organization_params
    params.require(:user).permit(:name, :fy_start_month)
  end

  def build_and_validate_user
    user = User.new(user_params.merge(admin: true))
    user.valid?
    user.errors.messages.reject! { |k, _v| k.to_s.include?("organization") }
    user
  end

  def redirect_using_devise
    if @user.active_for_authentication?
      set_flash_message! :notice, :signed_up
      sign_up(@user)
      respond_with @user, location: after_sign_up_path_for(@user)
    else
      set_flash_message! :notice, :"signed_up_but_#{@user.inactive_message}"
      expire_data_after_sign_in!
      respond_with @user, location: after_inactive_sign_up_path_for(@user)
    end
  end

  def update_user_tracker(organization)
    organization.update(created_by_id: @user.id, updated_by_id: @user.id)
  end
end
