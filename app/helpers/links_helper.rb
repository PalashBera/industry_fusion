module LinksHelper
  def excel_export_btn(controller_name)
    link_to '<i class="fas fa-file-export"></i><span class="d-none d-md-inline-block ml-1">Export</span>'.html_safe,
            url_for(controller: controller_name, action: "export", format: "xlsx"),
            class: "btn btn-dark", title: "Export #{controller_name.humanize.titleize}"
  end

  def remove_filter_btn(controller_name)
    link_to "Remove Filter", url_for(controller: controller_name, action: "index"), class: "btn btn-secondary"
  end

  def link_to_add_fields(form, association, path = "")
    new_object = form.object.public_send(association).klass.new
    id = new_object.object_id

    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      path.present? ? render(path, f: builder) : render(association.to_s.singularize + "_fields", f: builder)
    end

    link_to '<i class="mdi mdi-plus"></i> Add more'.html_safe, "#", class: "add_fields", data: { id: id, fields: fields.gsub("/n", "") }
  end

  def link_to_remove_fields
    link_to "<i class='fas fa-times text-danger'></i>".html_safe, "#", class: "remove_fields", title: "Remove Item"
  end

  def new_link(controller_name)
    link_to '<i class="fas fa-plus-circle"></i><span class="d-none d-md-inline-block ml-1">Add New</span>'.html_safe,
            url_for(controller: controller_name, action: "new"),
            class: "btn btn-primary", title: "Add New #{controller_name.singularize.humanize.titleize}"
  end

  def new_link_without_btn(controller_name)
    link_to "Add New",
            url_for(controller: controller_name, action: "new"),
            title: "Add New #{controller_name.singularize.humanize.titleize}"
  end

  def edit_link(controller_name, resource)
    link_to '<i class="mdi mdi-square-edit-outline"></i><span class="d-none d-md-inline-block ml-1">Edit</span>'.html_safe,
            url_for(controller: controller_name, action: "edit", id: resource.id),
            title: "Edit #{controller_name.singularize.humanize.titleize}",
            class: "dropdown-item"
  end

  def delete_link(controller_name, resource)
    link_to '<i class="mdi mdi-delete"></i><span class="d-none d-md-inline-block ml-1">Delete</span>'.html_safe,
            url_for(controller: controller_name, action: "destroy", id: resource.id),
            method: :delete, class: "text-danger", data: { confirm: "Are you sure?" },
            title: "Delete #{controller_name.singularize.humanize.titleize}"
  end

  def resend_user_invitation_link(user)
    link_to '<i class="mdi mdi-send mr-1"></i> Resend Invitation'.html_safe,
            resend_invitation_admin_user_path(user),
            method: :put, title: "Resend Invitation", class: "dropdown-item"
  end

  def resend_vendor_invitation_link(vendor)
    link_to '<i class="mdi mdi-send mr-1"></i> Resend Invitation'.html_safe,
            resend_invitation_master_vendor_path(vendor),
            method: :put, title: "Resend Invitation", class: "dropdown-item"
  end

  def new_link_without_icon(controller_name)
    link_to "Add New",
            url_for(controller: controller_name, action: "new"),
            title: "Add New #{controller_name.singularize.humanize.titleize}"
  end

  def assign_warehouse_link(controller_name, user)
    link_to '<i class="mdi mdi-office-building mr-1"></i> Assign Warehouse'.html_safe,
            url_for(controller: controller_name, action: "edit", id: user.id),
            data: { remote: true }, title: "Assign Warehouse", class: "dropdown-item"
  end

  def deactivation_link(controller_name, user)
    link_to '<i class="mdi mdi-block-helper mr-1"></i> Deactivate'.html_safe,
            url_for(controller: controller_name, action: "toggle_activation", id: user.id),
            title: "Deactivate", data: { confirm: "Are you sure?" }, class: "dropdown-item"
  end

  def activation_link(controller_name, user)
    link_to '<i class="mdi mdi-check-decagram mr-1"></i> Activate'.html_safe,
            url_for(controller: controller_name, action: "toggle_activation", id: user.id),
            title: "Activate", data: { confirm: "Are you sure?" }, class: "dropdown-item"
  end

  def show_link(controller_name, resource)
    link_to '<i class="mdi mdi-information-outline"></i><span class="d-none d-md-inline-block ml-1">Show</span>'.html_safe,
            url_for(controller: controller_name, action: "show", id: resource.id), title: "Show #{controller_name.singularize.humanize.titleize}", class: "dropdown-item"
  end
end
