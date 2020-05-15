module VendorsHelper
  def vendor_status(vendor)
    if vendor.invitation_accepted_at.nil?
      '<span class="badge badge-secondary" title="Pending">Pending</span>'.html_safe
    else
      '<span class="badge badge-success" title="Active">Active</span>'.html_safe
    end
  end
end
