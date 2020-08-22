module ModalLinksHelper
  def new_link_using_modal(controller_name)
    link_to raw('<i class="fas fa-plus-circle"></i><span class="d-none d-sm-inline-block ml-1">Add New</span>'),
            url_for(controller: controller_name, action: "new"),
            data: { remote: true },
            title: "Add New #{controller_name.singularize.humanize.titleize}",
            class: "btn btn-primary"
  end

  def edit_link_using_modal(controller_name, resource)
    link_to "Edit",
            url_for(controller: controller_name, action: "edit", id: resource.id),
            data: { remote: true },
            title: "Edit #{controller_name.singularize.humanize.titleize}",
            class: "btn btn-sm btn-secondary"
  end

  def history_link_using_modal(controller_name, resource)
    link_to "History",
            url_for(controller: controller_name, action: "change_logs", id: resource.id),
            data: { remote: true },
            title: "Show History",
            class: "btn btn-sm btn-secondary"
  end

  def filter_link_using_modal(params)
    link_to raw('<i class="fas fa-filter"></i><span class="d-none d-sm-inline-block ml-1">Filter</span>'),
            "#",
            data: { toggle: "modal", target: "#filter_modal" },
            title: params.present? ? "Filter Applied" : "Filter",
            class: "btn btn-primary"
  end

  def import_link_using_modal(controller_name)
    link_to raw('<i class="fas fa-file-import"></i><span class="d-none d-sm-inline-block ml-1">Import</span>'),
            "#",
            data: { toggle: "modal", target: "#import_modal" },
            title: "Import #{controller_name.humanize.titleize}",
            class: "btn btn-secondary"
  end

  def new_modal_link(controller_name)
    link_to raw("<b>Add New</b>"),
            url_for(controller: controller_name, action: "new"),
            data: { remote: true },
            title: "Add New #{controller_name.singularize.humanize.titleize}"
  end

  def show_link_modal_link(controller_name, resource)
    link_to "Show",
            url_for(controller: controller_name, action: "show", id: resource.id),
            remote: true,
            title: "Show #{resource.class.name}",
            class: "btn btn-sm btn-secondary"
  end

  def active_note_display_link(item)
    link_to raw('<i class="fas fa-sticky-note"></i>'),
            procurement_indent_path(item),
            remote: true,
            title: "Show Note",
            class: "text-info"
  end

  def disabled_note_display_link
    raw('<i class="fas fa-sticky-note disabled-icon-link" title="No note present"></i>')
  end
end
