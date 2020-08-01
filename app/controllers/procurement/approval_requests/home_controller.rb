class Procurement::ApprovalRequests::HomeController < Procurement::HomeController
  before_action { active_sidebar_option("approval_requests") }
end
