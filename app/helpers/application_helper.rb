module ApplicationHelper
  include Pagy::Frontend

  def full_title(page_title = "")
    base_title = "Industry Fusion"

    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def new_link_using_modal(controller_name)
    link_to "Add New",
            url_for(controller: controller_name, action: "new"),
            data: { remote: true },
            class: "btn btn-primary",
            title: "Add New #{controller_name.singularize.humanize.titleize}"
  end

  def edit_link_using_modal(controller_name, resource)
    link_to "Edit",
            url_for(controller: controller_name, action: "edit", id: resource.id),
            data: { remote: true },
            class: "btn btn-sm btn-info",
            title: "Edit #{controller_name.singularize.humanize.titleize}"
  end

  def delete_link(controller_name, resource)
    link_to "Delete",
            url_for(controller: controller_name, action: "destroy", id: resource.id),
            data: { confirm: "Are you sure?" },
            class: "btn btn-sm btn-danger",
            title: "Delete #{controller_name.singularize.humanize.titleize}"
  end
end
