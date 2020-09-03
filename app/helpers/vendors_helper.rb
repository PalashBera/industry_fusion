module VendorsHelper
  def archive_link(vendorship)
    link_to "Archive",
            master_vendor_path(vendorship),
            method: :put,
            data: { confirm: "Are you sure do you want to archive?" },
            title: "Archive",
            class: "btn btn-sm btn-secondary"
  end

  def activate_link(vendorship)
    link_to "Activate",
            master_vendor_path(vendorship),
            method: :put,
            data: { confirm: "Are you sure do you want to activate?" },
            title: "Activate",
            class: "btn btn-sm btn-secondary"
  end

  def resend_vendor_invitation_action_link(vendor)
    link_to "Resend Invitation",
            resend_invitation_master_vendor_path(vendor),
            method: :put,
            data: { confirm: "Are you sure do you want to resend invitation?" },
            title: "Resend Invitation",
            class: "btn btn-sm btn-secondary"
  end

  def vendorship_action_btn(vendorship)
    if vendorship.vendor.pending?
      resend_vendor_invitation_action_link(vendorship.vendor)
    elsif vendorship.archive?
      activate_link(vendorship)
    else
      archive_link(vendorship)
    end
  end
end
