module ModalLinksHelper
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

  def filter_button(params)
    link_to '<i class="fas fa-filter"></i><span class="d-none d-md-inline-block ml-1">Filter</span>'.html_safe,
            "#",
            class: "btn btn-#{params.present? ? "warning" : "secondary"}",
            data: { toggle: "modal", target: "#filter_modal" }, title: params.present? ? "Filter Applied" : "Filter"
  end

  def import_modal_btn(controller_name)
    link_to '<i class="fas fa-file-import"></i><span class="d-none d-md-inline-block ml-1">Import</span>'.html_safe,
            "#", class: "btn btn-info", data: { toggle: "modal", target: "#import_modal" }, title: "Import #{controller_name.humanize.titleize}"
  end

  def new_modal_link(controller_name)
    link_to "<b>Add New</b>".html_safe,
            url_for(controller: controller_name, action: "new"),
            data: { remote: true }, class: "ml-1", title: "Add New #{controller_name.singularize.humanize.titleize}"
  end
end
