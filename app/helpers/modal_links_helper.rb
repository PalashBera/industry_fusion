module ModalLinksHelper
  def new_link_using_modal(controller_name)
    link_to raw('<i class="fas fa-plus-circle"></i><span class="d-none d-md-inline-block ml-1">Add New</span>'),
            url_for(controller: controller_name, action: "new"),
            data: { remote: true },
            title: "Add New #{controller_name.singularize.humanize.titleize}",
            class: "btn btn-primary"
  end

  def edit_link_using_modal(controller_name, resource)
    link_to raw('<i class="mdi mdi-square-edit-outline mr-1"></i> Edit'),
            url_for(controller: controller_name, action: "edit", id: resource.id),
            data: { remote: true },
            title: "Edit #{controller_name.singularize.humanize.titleize}",
            class: "dropdown-item"
  end

  def show_modal_link(controller_name, resource)
    link_to raw('<i class="mdi mdi-information-outline"></i> Show'),
            url_for(controller: controller_name, action: "show", id: resource.id),
            title: "Show #{resource.class.name}",
            class: "dropdown-item",
            remote: true
  end

  def change_logs_link_using_modal(controller_name, resource)
    link_to raw('<i class="mdi mdi-history mr-1"></i> Change Log'),
            url_for(controller: controller_name, action: "change_logs", id: resource.id),
            data: { remote: true },
            title: "Show Change Logs",
            class: "dropdown-item"
  end

  def filter_link_using_modal(params)
    link_to raw('<i class="fas fa-filter"></i><span class="d-none d-md-inline-block ml-1">Filter</span>'),
            "#",
            data: { toggle: "modal", target: "#filter_modal" },
            title: params.present? ? "Filter Applied" : "Filter",
            class: "btn btn-#{params.present? ? "warning" : "secondary"}"
  end

  def import_link_using_modal(controller_name)
    link_to raw('<i class="fas fa-file-import"></i><span class="d-none d-md-inline-block ml-1">Import</span>'),
            "#",
            data: { toggle: "modal", target: "#import_modal" },
            title: "Import #{controller_name.humanize.titleize}",
            class: "btn btn-info"
  end

  def new_modal_link(controller_name)
    link_to raw("<b>Add New</b>"),
            url_for(controller: controller_name, action: "new"),
            data: { remote: true },
            title: "Add New #{controller_name.singularize.humanize.titleize}",
            class: "ml-1"
  end

  def active_note_display_link(item)
    link_to raw('<i class="fas fa-sticky-note"></i>'),
            procurement_indent_item_path(item),
            remote: true,
            title: "Show Note",
            class: "text-info"
  end

  def disabled_note_display_link
    raw('<i class="fas fa-sticky-note disabled-icon-link" title="No note present"></i>')
  end
end
