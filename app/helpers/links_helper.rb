module LinksHelper
  def new_link_using_modal(controller_name)
    link_to '<i class="fas fa-plus-circle"></i> Add New'.html_safe,
            url_for(controller: controller_name, action: "new"),
            data: { remote: true },
            class: "btn btn-primary",
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
    link_to '<i class="fas fa-file-export"></i> Export'.html_safe,
            url_for(controller: controller_name, action: "export", format: "xlsx"),
            class: "btn btn-dark",
            title: "Export #{controller_name.humanize.titleize}"
  end

  def filter_button(params)
    link_to '<i class="fas fa-filter"></i> Filter'.html_safe,
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

  def remove_selection_link
    link_to '<i class="fas fa-minus-circle"></i>'.html_safe,
            "#",
            class: "remove-selectpicker-selections"
  end

  def import_modal_btn(controller_name)
    link_to '<i class="fas fa-file-import"></i> Import'.html_safe,
            "#",
            class: "btn btn-info",
            data: { toggle: "modal", target: "#import_modal" },
            title: "Import #{controller_name.humanize.titleize}"
  end
end
