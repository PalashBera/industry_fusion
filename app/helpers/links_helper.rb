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
            class: "btn btn-dark btn-small no-preloader",
            title: "Export #{controller_name.humanize.titleize}"
  end

  def filter_button(params)
    link_to '<i class="fas fa-filter"></i><span class="d-none d-md-inline-block ml-1">Filter</span>'.html_safe,
            "#",
            class: "btn btn-#{params.present? ? "warning" : "secondary"} btn-small no-preloader",
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
            class: "remove-selectpicker-selections no-preloader"
  end

  def import_modal_btn(controller_name)
    link_to '<i class="fas fa-file-import"></i><span class="d-none d-md-inline-block ml-1">Import</span>'.html_safe,
            "#",
            class: "btn btn-info btn-small no-preloader",
            data: { toggle: "modal", target: "#import_modal" },
            title: "Import #{controller_name.humanize.titleize}"
  end
end
