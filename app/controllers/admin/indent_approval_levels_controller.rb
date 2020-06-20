class Admin::IndentApprovalLevelsController < Admin::HomeController
  def index
    @search = ApprovalLevel.indent.ransack(params[:q])
    @pagy, @approval_levels = pagy(@search.result(distinct: true).included_resources, items: 20)
  end

  def new
    @approval_level = ApprovalLevel.new
    @level_users = @approval_level.level_users.build
  end

  def create
    @approval_level = ApprovalLevel.new(approval_level_params)

    if @approval_level.save
      redirect_to admin_indent_approval_levels_path, flash: { success: t("flash_messages.created", name: "Indent Approval Level") }
    else
      render "new"
    end
  end

  def edit
    approval_level
  end

  def update
    if approval_level.update(approval_level_params)
      redirect_to admin_indent_approval_levels_path, flash: { success: t("flash_messages.updated", name: "Indent Approval Level") }
    else
      render "edit"
    end
  end

  def destroy
    approval_level.destroy
    redirect_to admin_indent_approval_levels_path, flash: { success: t("flash_messages.deleted", name: "Indent Approval Level") }
  end

  private

  def approval_level_params
    params.require(:approval_level).permit(:approval_type, level_users_attributes: [:id, :user_id, :approval_level_id, :_destroy] )
  end

  def approval_level
    @approval_level ||= ApprovalLevel.find(params[:id])
  end
end
