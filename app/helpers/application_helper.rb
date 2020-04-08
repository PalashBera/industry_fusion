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
      "Well done!"
    elsif message_type == "info"
      "Heads up!"
    elsif message_type == "danger"
      "Oh snap!"
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

  def archive_status(value)
    if value
      '<span class="badge badge-danger" title="Archived">Archived</span>'
    else
      '<span class="badge badge-success" title="Active">Active</span>'
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
end
