module QuotationRequestsHelper
  def indent_selection_link_btn
    link_to raw('<i class="fas fa-plus-circle"></i><span class="d-none d-sm-inline-block ml-1">Add New</span>'),
            indent_selection_new_procurement_quotation_request_path,
            title: "Add New Quotation Request",
            class: "btn btn-primary"
  end

  def indent_selection_link
    link_to "Add New",
            indent_selection_new_procurement_quotation_request_path,
            title: "Add New Quotation Request"
  end

  def vendor_selection_link_btn
    link_to raw('<span class="d-none d-sm-inline-block mr-1">Select Vendors</span><i class="fas fa-arrow-right"></i>'),
            vendor_selection_new_procurement_quotation_request_path,
            title: "Select Vendors",
            class: "btn btn-primary"
  end

  def indent_selection_back_link_btn
    link_to raw('<i class="fas fa-arrow-left"></i><span class="d-none d-sm-inline-block ml-1">Back</span>'),
            indent_selection_new_procurement_quotation_request_path,
            title: "Back to Indent Selection",
            class: "btn btn-secondary"
  end

  def vendorship_selection_back_link_btn
    link_to raw('<i class="fas fa-arrow-left"></i><span class="d-none d-sm-inline-block ml-1">Back</span>'),
            vendor_selection_new_procurement_quotation_request_path,
            title: "Back to Vendor Selection",
            class: "btn btn-secondary"
  end

  def preview_quotation_request_link_btn
    link_to raw('<span class="d-none d-sm-inline-block mr-1">Preview</span><i class="fas fa-arrow-right"></i>'),
            preview_new_procurement_quotation_request_path,
            title: "Preview Quotation Request",
            class: "btn btn-primary"
  end
end
