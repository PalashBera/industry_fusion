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

  def activation_action_link(controller_name, user)
    link_to raw('<i class="mdi mdi-check-decagram mr-1"></i> Activate'),
            url_for(controller: controller_name, action: "toggle_activation", id: user.id),
            data: { confirm: "Are you sure?" },
            title: "Activate",
            class: "dropdown-item"
  end

  def deactivation_action_link(controller_name, user)
    link_to raw('<i class="mdi mdi-block-helper mr-1"></i> Deactivate'),
            url_for(controller: controller_name, action: "toggle_activation", id: user.id),
            data: { confirm: "Are you sure?" },
            title: "Deactivate",
            class: "dropdown-item"
  end

  def assign_warehouse_action_link(controller_name, user)
    link_to raw('<i class="mdi mdi-office-building mr-1"></i> Assign Warehouse'),
            url_for(controller: controller_name, action: "edit", id: user.id),
            data: { remote: true },
            title: "Assign Warehouses",
            class: "dropdown-item"
  end

  def resend_user_invitation_action_link(user)
    link_to raw('<i class="mdi mdi-send mr-1"></i> Resend Invitation'),
            resend_invitation_admin_user_path(user),
            method: :put,
            title: "Resend Invitation",
            class: "dropdown-item"
  end

  def resend_vendor_invitation_action_link(vendor)
    link_to raw('<i class="mdi mdi-send mr-1"></i> Resend Invitation'),
            resend_invitation_master_vendor_path(vendor),
            method: :put,
            title: "Resend Invitation",
            class: "dropdown-item"
  end
end
