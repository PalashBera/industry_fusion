class Procurement::ApprovalRequests::HomeController < Procurement::HomeController
  before_action { active_sidebar_sub_menu_option("approval_requests") }
end
