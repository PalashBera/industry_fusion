module LinksHelper
  def new_link_using_modal(controller_name)
    link_to '<i class="fas fa-plus-circle"></i><span class="d-none d-md-inline-block ml-1">Add New</span>'.html_safe,
            url_for(controller: controller_name, action: "new"),
            data: { remote: true }, class: "btn btn-primary", title: "Add New #{controller_name.singularize.humanize.titleize}"
  end

  def edit_link_using_modal(controller_name, resource)
    link_to '<i class="mdi mdi-square-edit-outline mr-1"></i> Edit'.html_safe,
            url_for(controller: controller_name, action: "edit", id: resource.id),
            data: { remote: true }, title: "Edit #{controller_name.singularize.humanize.titleize}", class: "dropdown-item"
  end

  def change_logs_link_using_modal(controller_name, resource)
    link_to '<i class="mdi mdi-history mr-1"></i> Change Log'.html_safe,
            url_for(controller: controller_name, action: "change_logs", id: resource.id),
            data: { remote: true }, title: "Show Change Logs", class: "dropdown-item"
  end

  def excel_export_btn(controller_name)
    link_to '<i class="fas fa-file-export"></i><span class="d-none d-md-inline-block ml-1">Export</span>'.html_safe,
            url_for(controller: controller_name, action: "export", format: "xlsx"),
            class: "btn btn-dark", title: "Export #{controller_name.humanize.titleize}"
  end

  def filter_button(params)
    link_to '<i class="fas fa-filter"></i><span class="d-none d-md-inline-block ml-1">Filter</span>'.html_safe,
            "#",
            class: "btn btn-#{params.present? ? "warning" : "secondary"}",
            data: { toggle: "modal", target: "#filter_modal" },
            title: params.present? ? "Filter Applied" : "Filter"
  end

  def remove_filter_btn(controller_name)
    link_to "Remove Filter",
            url_for(controller: controller_name, action: "index"),
            class: "btn btn-secondary"
  end

  def import_modal_btn(controller_name)
    link_to '<i class="fas fa-file-import"></i><span class="d-none d-md-inline-block ml-1">Import</span>'.html_safe,
            "#",
            class: "btn btn-info", data: { toggle: "modal", target: "#import_modal" }, title: "Import #{controller_name.humanize.titleize}"
  end

  def link_to_add_fields(form, association)
    new_object = form.object.public_send(association).klass.new
    id = new_object.object_id

    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end

    link_to '<i class="fa fa-plus"></i> Add more items'.html_safe, "#",
            class: "add_fields", data: { id: id, fields: fields.gsub("/n", "") }
  end

  def link_to_remove_fields
    link_to "<i class='fas fa-times text-danger'></i>".html_safe,
            "#", class: "remove_fields", title: "Remove Item"
  end

  def new_link(controller_name)
    link_to '<i class="fas fa-plus-circle"></i><span class="d-none d-md-inline-block ml-1">Add New</span>'.html_safe,
            url_for(controller: controller_name, action: "new"),
            class: "btn btn-primary", title: "Add New #{controller_name.singularize.humanize.titleize}"
  end

  def edit_link(controller_name, resource)
    link_to '<i class="fas fa-edit text-warning"></i>'.html_safe,
            url_for(controller: controller_name, action: "edit", id: resource.id),
            title: "Edit #{controller_name.singularize.humanize.titleize}"
  end

  def edit_link_for_dropdown(controller_name, resource)
    link_to '<i class="mdi mdi-square-edit-outline mr-1"></i> Edit'.html_safe,
            url_for(controller: controller_name, action: "edit", id: resource.id),
            title: "Edit #{controller_name.singularize.humanize.titleize}",
            class: "dropdown-item"
  end

  def show_link_for_dropdown(controller_name, resource)
    link_to '<i class="mdi mdi-eye mr-1"></i> Show Details'.html_safe,
            url_for(controller: controller_name, action: "show", id: resource.id),
            title: "Show #{controller_name.singularize.humanize.titleize}",
            class: "dropdown-item"
  end

  def resend_user_invitation_link(user)
    link_to '<i class="mdi mdi-send mr-1"></i> Resend Invitation'.html_safe,
            resend_invitation_admin_user_path(user), method: :put, title: "Resend Invitation", class: "dropdown-item"
  end

  def resend_vendor_invitation_link(vendor)
    link_to '<i class="mdi mdi-send mr-1"></i> Resend Invitation'.html_safe,
            resend_invitation_master_vendor_path(vendor), method: :put, title: "Resend Invitation", class: "dropdown-item"
  end

  def new_modal_link(controller_name)
    link_to "<b>Add New</b>".html_safe,
            url_for(controller: controller_name, action: "new"),
            data: { remote: true },
            class: "ml-1",
            title: "Add New #{controller_name.singularize.humanize.titleize}"
  end
end
