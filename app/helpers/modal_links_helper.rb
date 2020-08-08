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

  def note_display_link(controller_name, item, indent_id)
    link_to item.note.present? ? raw('<i class="mdi mdi-note" style="color: red;"></i>') : raw('<i class="mdi mdi-note-outline" style="color: #742ed3;"></i>'),
            url_for(controller: controller_name, action: "show", indent_item_id: item.id, id: indent_id),
            remote: true,
            title: "Show Note",
            class: "ml-1"
  end
end
