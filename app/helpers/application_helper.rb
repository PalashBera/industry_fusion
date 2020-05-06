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
    elsif message_type == "error"
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
      "error"
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

  def active_class(controller)
    current_page?(controller: controller) ? "active" : ""
  end
end
