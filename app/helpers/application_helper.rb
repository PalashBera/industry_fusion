module ApplicationHelper
  include Pagy::Frontend

  def full_title(page_title = "")
    base_title = t("page_title")

    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def flash_message_prefix(message_type)
    case message_type
    when "success" then t("alert_prefix.success")
    when "info"    then t("alert_prefix.info")
    when "warning" then t("alert_prefix.warning")
    when "danger"  then t("alert_prefix.danger")
    else ""
    end
  end

  def message_type(message_type)
    case message_type
    when "notice" then t("message_type.notice")
    when "alert"  then t("message_type.alert")
    else message_type
    end
  end

  def archive_status(archived)
    if archived
      '<span class="badge badge-danger" title="Archived">Archived</span>'
    else
      '<span class="badge badge-success" title="Active">Active</span>'
    end
  end

  def active_class(str)
    str == controller_name ? t("active") : ""
  end
end
