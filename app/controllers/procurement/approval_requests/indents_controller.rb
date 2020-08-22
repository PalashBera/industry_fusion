class Procurement::ApprovalRequests::IndentsController < Procurement::ApprovalRequests::HomeController
  def index
    @search = IndentItem.joins(:indent).ransack(params[:q])
    indent_items = @search.result.approval_pending.pending_for_approval(current_user.id)
    @total_count = indent_items.count
    @bordered_item_ids = indent_items.group_by(&:indent_id).map { |_k, v| v.last.id }
    @pagy, @indent_items = pagy_countless(indent_items.included_resources, link_extra: 'data-remote="true"')
  end

  def update
    indent_item = IndentItem.find(params[:id])
    approval_request = indent_item.approval_request

    if approval_request
      @approval_request_user = approval_request.approval_request_users.user_filter(current_user.id).first
      falsh_message = generate_message
    else
      falsh_message = "Indent has been #{approval_request.action_type} already."
    end

    redirect_to procurement_approval_requests_indents_path, flash: { success: falsh_message }
  end

  private

  def generate_message
    if %w[approve reject].include?(params[:type])
      @approval_request_user.public_send(params[:type])
    else
      "You tried with unpermitted parameters."
    end
  end
end
