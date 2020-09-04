module ActionLinksHelper
  def edit_action_link(controller_name, resource)
    link_to raw('<i class="mdi mdi-square-edit-outline"></i> Edit'),
            url_for(controller: controller_name, action: "edit", id: resource.id),
            title: "Edit #{controller_name.singularize.humanize.titleize}",
            class: "dropdown-item"
  end

  def show_action_link(controller_name, resource)
    link_to raw('<i class="mdi mdi-information-outline"></i> Show'),
            url_for(controller: controller_name, action: "show", id: resource.id),
            title: "Show #{resource.class.name}",
            class: "dropdown-item"
  end

  def print_action_link(controller_name, resource)
    link_to raw('<i class="mdi mdi-printer"></i> Print'),
            url_for(controller: controller_name, action: "print", id: resource.id),
            title: "Print",
            class: "dropdown-item",
            target: "_blank"
  end

  def send_approval_action_link(controller_name, resource)
    link_to raw('<i class="mdi mdi-account-check-outline"></i> Send for Approval'),
            url_for(controller: controller_name, action: "send_for_approval", id: resource.id),
            title: "Send for Approval",
            class: "dropdown-item"
  end

  def restore_action_link(controller_name, resource)
    link_to raw('<i class="mdi mdi-backup-restore"></i> Restore'),
            url_for(controller: controller_name, action: "destroy", id: resource.id),
            method: :delete,
            data: { confirm: "Do you want to restore this indent?" },
            title: "Restore",
            class: "dropdown-item"
  end

  def amended_action_link(controller_name, resource)
    link_to raw('<i class="mdi mdi-cancel"></i> Amend'),
            url_for(controller: controller_name, action: "destroy", id: resource.id),
            method: :delete,
            data: { confirm: "Do you want to amend this indent?" },
            title: "Amend",
            class: "dropdown-item"
  end

  def cancelled_action_link(controller_name, resource)
    link_to raw('<i class="mdi mdi-cancel"></i> Cancel'),
            url_for(controller: controller_name, action: "destroy", id: resource.id),
            method: :delete,
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
end
