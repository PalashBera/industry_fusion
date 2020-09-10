module QuotationRequestsHelper
  def indent_selection_link_btn(controller_name)
    link_to raw('<i class="fas fa-plus-circle"></i><span class="d-none d-sm-inline-block ml-1">Add New</span>'),
            url_for(controller: controller_name, action: "indent_selection"),
            title: "Add New #{controller_name.singularize.humanize.titleize}",
            class: "btn btn-primary"
  end

  def indent_selection_link(controller_name)
    link_to "Add New",
            url_for(controller: controller_name, action: "indent_selection"),
            title: "Add New #{controller_name.singularize.humanize.titleize}"
  end
end
