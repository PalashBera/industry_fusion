module ApplicationHelper
  def full_title(page_title = "")
    base_title = "Industry Fusion"

    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def delete_link(path, class_name = "")
    link_to "Delete".html_safe,
            path,
            method: :delete,
            data: { confirm: "Are you sure?" },
            class: class_name
  end
end
