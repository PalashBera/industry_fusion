class Procurement::PendingIndentsController < Procurement::IndentsController
  def index
    super
  end

  def new
    @indent = Indent.new
    @indent_item = @indent.indent_items.build
  end

  def show
    super
  end

  def create
    @indent = Indent.new(indent_params)

    if @indent.save
      redirect_to procurement_pending_indents_path, flash: { success: t("flash_messages.created", name: "Indent") }
    else
      render "new"
    end
  end

  def edit
    super
  end

  def update
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

  def indent
    super
  end

  def indent_params
    super
  end

  def redirect
    redirect_to procurement_pending_indents_path
  end

  def scope_method
    "pending"
  end

  def auth_verified?
    auth = Auth.decode(params[:token])
    @approval = Approval.find_by(id: auth.first["approval"])
    @user = User.find_by(id: auth.first["user"])
    @approval && @user && @approval.user_ids.include?(@user.id.to_s)
  end
end
