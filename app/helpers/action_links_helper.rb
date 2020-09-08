module ActionLinksHelper
  def edit_action_link(controller_name, resource)
    link_to "Edit",
            url_for(controller: controller_name, action: "edit", id: resource.id),
            title: "Edit #{controller_name.singularize.humanize.titleize}",
            class: "dropdown-item"
  end

  def show_action_link(controller_name, resource)
    link_to "Show",
            url_for(controller: controller_name, action: "show", id: resource.id),
            title: "Show #{controller_name.singularize.humanize.titleize}",
            class: "dropdown-item"
  end

  def print_action_link(controller_name, resource)
    link_to "Print",
            url_for(controller: controller_name, action: "print", id: resource.id),
            title: "Print",
            class: "dropdown-item",
            target: "_blank"
  end

  def send_approval_action_link(controller_name, resource)
    link_to "Send for Approval",
            url_for(controller: controller_name, action: "send_for_approval", id: resource.id),
            method: :put,
            data: { confirm: "Do you want to send for approval this indent?" },
            title: "Send for Approval",
            class: "dropdown-item"
  end

  def restore_action_link(controller_name, resource)
    link_to "Restore",
            url_for(controller: controller_name, action: "restore", id: resource.id),
            method: :put,
            data: { confirm: "Do you want to restore this indent?" },
            title: "Restore",
            class: "dropdown-item"
  end

  def amended_action_link(controller_name, resource)
    link_to "Amend",
            url_for(controller: controller_name, action: "amend", id: resource.id),
            method: :put,
            data: { confirm: "Do you want to amend this indent?" },
            title: "Amend",
            class: "dropdown-item"
  end

  def cancelled_action_link(controller_name, resource)
    link_to "Cancel",
            url_for(controller: controller_name, action: "cancel", id: resource.id),
            method: :put,
            data: { confirm: "Do you want to cancel this indent?" },
            title: "Cancel",
            class: "dropdown-item"
  end

  def activation_action_link(controller_name, resource)
    link_to "Activate",
            url_for(controller: controller_name, action: "toggle_archive", id: resource.id),
            data: { confirm: "Are you sure do you want to activate?" },
            title: "Activate",
            class: "btn btn-sm btn-secondary"
  end

  def archive_action_link(controller_name, resource)
    link_to "Archive",
            url_for(controller: controller_name, action: "toggle_archive", id: resource.id),
            data: { confirm: "Are you sure do you want to archive?" },
            title: "Archive",
            class: "btn btn-sm btn-secondary"
  end

  def history_action_link_using_modal(controller_name, resource)
    link_to "History",
            url_for(controller: controller_name, action: "change_logs", id: resource.id),
            data: { remote: true },
            title: "Show History",
            class: "dropdown-item"
  end
end
