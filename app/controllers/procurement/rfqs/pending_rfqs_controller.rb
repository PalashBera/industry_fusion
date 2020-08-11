class Procurement::Rfqs::PendingRfqsController < Procurement::Rfqs::HomeController
  def index
    @pagy, @rfqs = pagy_countless(Rfq.all.included_resources, link_extra: 'data-remote="true"')
  end
end
