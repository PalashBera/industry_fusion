class Procurement::Indents::PendingIndentsController < Procurement::Indents::HomeController
  def index
    super
  end

  def new
    super
  end

  def show
    super
  end

  def create
    super
  end

  def edit
    super
  end

  def update
    super
  end

  def destroy
    super
  end

  def print
    super
  end

  def send_for_approval
    super
  end

  def email_approval
    if auth_verified?
      @message = @approval.approve(@user.id)
    else
      @message = "Invaid access. Please try again using application."
    end
  end

  def email_rejection
    if auth_verified?
      @message = @approval.reject(@user.id)
    else
      @message = "Invaid access. Please try again using application."
    end
  end

  private

  def redirect_path
    procurement_pending_indents_path
  end

  def scope_method
    "pending"
  end

  def delete_method
    "mark_as_cancelled"
  end

  def destroy_flash_message
    t("flash_messages.cancelled", name: "Indent")
  end

  def auth_verified?
    auth = Auth.decode(params[:token])
    @approval = Approval.find_by(id: auth.first["approval"])
    @user = User.find_by(id: auth.first["user"])
    @approval && @user && @approval.user_ids.include?(@user.id.to_s)
  end
end
