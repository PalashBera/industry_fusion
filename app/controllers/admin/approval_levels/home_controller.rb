class Admin::ApprovalLevels::HomeController < Admin::HomeController
  before_action { active_sidebar_option("approval_levels") }

  protected

  def index
    @approval_levels = ApprovalLevel.public_send(controller_name).included_resources
  end

  def new
    @approval_level = ApprovalLevel.new
    @level_users = @approval_level.level_users.build
  end

  def create
    @approval_level = ApprovalLevel.new(approval_level_params)

    if check_user_availability && @approval_level.save
      redirect_to public_send("admin_approval_levels_#{controller_name}_path"), flash: { success: t("flash_messages.created", name: flash_message_title) }
    else
      render "new"
    end
  end

  def edit
    approval_level
  end

  def update
    if check_user_availability && approval_level.update(approval_level_params)
      redirect_to public_send("admin_approval_levels_#{controller_name}_path"), flash: { success: t("flash_messages.updated", name: flash_message_title) }
    else
      approval_level.attributes = approval_level_params
      render "edit"
    end
  end

  def destroy
    approval_level.destroy
    redirect_to public_send("admin_approval_levels_#{controller_name}_path"), flash: { error: t("flash_messages.deleted", name: flash_message_title) }
  end

  def flash_message_title
    raise NotImplementedError
  end

  private

  def approval_level_params
    params.require(:approval_level).permit(level_users_attributes: %i[id user_id approval_level_id _destroy]).merge(approval_type: controller_name)
  end

  def approval_level
    @approval_level ||= ApprovalLevel.find(params[:id])
  end

  def check_user_availability
    @approval_level ||= approval_level
    blocked_users = ApprovalLevel.indents.reject { |al| al.id == @approval_level.id }.map(&:user_ids).flatten
    form_users = []

    approval_level_params[:level_users_attributes].each do |_k, v|
      form_users << v["user_id"].to_i if v["_destroy"] == "false"
    end

    not_allow_to_save = (blocked_users & form_users).present? || form_users.length != form_users.uniq.length

    approval_level.errors.add(:base, "User is already present in #{flash_message_title.downcase}")
    !not_allow_to_save
  end
end
