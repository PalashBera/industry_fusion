module QuotationRequestsHelper
  def indent_selection_link_btn(controller_name)
    link_to raw('<i class="fas fa-plus-circle"></i><span class="d-none d-sm-inline-block ml-1">Add New</span>'),
            url_for(controller: controller_name, action: "indent_selection"),
            title: "Add New Quotation Request",
            class: "btn btn-primary"
  end

  def indent_selection_link(controller_name)
    link_to "Add New",
            url_for(controller: controller_name, action: "indent_selection"),
            title: "Add New Quotation Request"
  end

  def vendor_selection_link_btn(controller_name)
    link_to raw('<span class="d-none d-sm-inline-block mr-1">Select Vendors</span><i class="fas fa-arrow-right"></i>'),
            url_for(controller: controller_name, action: "vendor_selection"),
            title: "Select Vendors",
            class: "btn btn-primary"
  end

  def indent_selection_back_link_btn(controller_name)
    link_to raw('<i class="fas fa-arrow-left"></i><span class="d-none d-sm-inline-block ml-1">Back</span>'),
            url_for(controller: controller_name, action: "indent_selection"),
            title: "Back to Indent Selection",
            class: "btn btn-secondary"
  end
end
