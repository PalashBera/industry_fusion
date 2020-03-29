module ModalFormable
  extend ActiveSupport::Concern

  def class_title
    self.class.name.underscore.humanize.titleize
  end

  def button_name
    new_record? ? "Create" : "Update"
  end

  def modal_header
    new_record? ? "New #{class_title}" : "Edit #{class_title}"
  end
end
