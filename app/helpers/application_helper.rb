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

  def flash_message_prefix(message_type)
    if message_type == "success"
      "<b>Well done!</b>"
    elsif message_type == "info"
      "<b>Heads up!</b>"
    elsif message_type == "danger"
      "<b>Oh snap!</b>"
    else
      ""
    end
  end

  def message_type(message_type)
    case message_type
    when "notice"
      "info"
    when "alert"
      "danger"
    else
      message_type
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
