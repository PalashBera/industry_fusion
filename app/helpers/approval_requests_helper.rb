module ApprovalRequestsHelper
  def approve_action_link(controller_name, resource)
    link_to raw('<i class="mdi mdi-checkbox-marked-circle-outline"></i> Approve'),
            url_for(controller: controller_name, action: "update", id: resource.id, type: "approve"),
            method: :put,
            data: { confirm: "Are you sure you want to approve?" },
            title: "Approve",
            class: "dropdown-item"
  end

  def reject_action_link(controller_name, resource)
    link_to raw('<i class="mdi mdi-cancel"></i> Reject'),
            url_for(controller: controller_name, action: "update", id: resource.id, type: "reject"),
            method: :put,
            data: { confirm: "Are you sure you want to reject?" },
            title: "Reject",
            class: "dropdown-item"
  end
end
