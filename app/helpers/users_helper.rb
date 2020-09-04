module UsersHelper
  def user_status(user)
    if user.admin?
      "Active"
    elsif user.archive?
      "Archived"
    elsif user.pending_invitation?
      "Pending"
    else
      "Actived"
    end
  end

  def user_role(user)
    if user.admin?
      "Admin"
    else
      "General User"
    end
  end

  def resend_user_invitation_action_link(user)
    link_to "Resend Invitation",
            resend_invitation_admin_user_path(user),
            method: :put,
            data: { confirm: "Are you sure do you want to resend invitation?" },
            title: "Resend Invitation",
            class: "btn btn-sm btn-secondary"
  end

  def assign_warehouse_action_link(controller_name, user)
    link_to "Assign Warehouse",
            url_for(controller: controller_name, action: "edit", id: user.id),
            data: { remote: true },
            title: "Assign Warehouse",
            class: "btn btn-sm btn-secondary"
  end
end
