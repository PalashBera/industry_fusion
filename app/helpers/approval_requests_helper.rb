module ApprovalRequestsHelper
  def approve_action_link(controller_name, resource)
    link_to "Approve",
            url_for(controller: controller_name, action: "update", id: resource.id, type: "approve"),
            method: :put,
            data: { confirm: "Are you sure you want to approve?" },
            title: "Approve",
            class: "btn btn-sm btn-secondary"
  end

  def reject_action_link(controller_name, resource)
    link_to "Reject",
            url_for(controller: controller_name, action: "update", id: resource.id, type: "reject"),
            method: :put,
            data: { confirm: "Are you sure you want to reject?" },
            title: "Reject",
            class: "btn btn-sm btn-secondary"
  end

  def arrange_histories(approval_requests)
    rearranged_histories = []
    current_group = []

    approval_requests.each do |approval_request|
      current_group << approval_request

      if approval_request.next_approval_request_id.nil?
        rearranged_histories.unshift(current_group)
        current_group = []
      end
    end

    rearranged_histories
  end
end
