module LinksHelper
  def new_link_using_modal(controller_name)
    link_to '<i class="fas fa-plus-circle"></i><span class="d-none d-md-inline-block ml-1">Add New</span>'.html_safe,
            url_for(controller: controller_name, action: "new"),
            data: { remote: true },
            class: "btn btn-primary btn-small",
            title: "Add New #{controller_name.singularize.humanize.titleize}"
  end

  def edit_link_using_modal(controller_name, resource)
    link_to '<i class="fas fa-edit text-primary"></i>'.html_safe,
            url_for(controller: controller_name, action: "edit", id: resource.id),
            data: { remote: true },
            title: "Edit #{controller_name.singularize.humanize.titleize}"
  end

  def change_logs_link_using_modal(controller_name, resource)
    link_to '<i class="fas fa-history text-info"></i>'.html_safe,
            url_for(controller: controller_name, action: "change_logs", id: resource.id),
            data: { remote: true },
            title: "Show Change Logs"
  end

  def excel_export_btn(controller_name)
    link_to '<i class="fas fa-file-export"></i><span class="d-none d-md-inline-block ml-1">Export</span>'.html_safe,
            url_for(controller: controller_name, action: "export", format: "xlsx"),
            class: "btn btn-dark btn-small",
            title: "Export #{controller_name.humanize.titleize}"
  end

  def filter_button(params)
    link_to '<i class="fas fa-filter"></i><span class="d-none d-md-inline-block ml-1">Filter</span>'.html_safe,
            "#",
            class: "btn btn-#{params.present? ? "warning" : "secondary"} btn-small",
            data: { toggle: "modal", target: "#filter_modal" },
            title: params.present? ? "Filter Applied" : "Filter"
  end

  def remove_filter_btn(controller_name)
    link_to "Remove Filter",
            url_for(controller: controller_name, action: "index"),
            class: "btn btn-secondary btn-xs-block order-2 order-sm-1"
  end

  def remove_selection_link
    link_to '<i class="fas fa-minus-circle"></i>'.html_safe,
            "#",
            class: "remove-selectpicker-selections"
  end

  def import_modal_btn(controller_name)
    link_to '<i class="fas fa-file-import"></i><span class="d-none d-md-inline-block ml-1">Import</span>'.html_safe,
            "#",
            class: "btn btn-info btn-small",
            data: { toggle: "modal", target: "#import_modal" },
            title: "Import #{controller_name.humanize.titleize}"
  end

  def link_to_add_fields(form, association)
    new_object = form.object.public_send(association).klass.new
    id = new_object.object_id

    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end

    link_to '<i class="fa fa-plus "></i> Add'.html_safe, "#",
            class: "add_fields",
            data: { id: id, fields: fields.gsub("/n", "") }
  end

  def link_to_remove_fields
    link_to "<i class='fas fa-times text-danger'></i>".html_safe,
            "#",
            class: "remove_fields"
  end

  def new_link(controller_name)
    link_to '<i class="fas fa-plus-circle"></i><span class="d-none d-md-inline-block ml-1">Add New</span>'.html_safe,
            url_for(controller: controller_name, action: "new"),
            class: "btn btn-primary btn-small",
            title: "Add New #{controller_name.singularize.humanize.titleize}"
  end

  def resend_invitation_link(user)
    link_to '<i class="far fa-paper-plane"></i>'.html_safe,
            resend_invitation_admin_user_path(user),
            method: :put,
            class: "ml-1",
            title: "Resend Invitation"
  end
end
