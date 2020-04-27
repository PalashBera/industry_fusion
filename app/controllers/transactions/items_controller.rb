class Transactions::ItemsController < Transactions::TransactionsController
  def makes
    makes = item.makes.included_resources
    render json: { makes: makes.as_json(only: :id, methods: :brand_name) }
  end

  def uoms
    uoms = item.uoms.sort_by(&:short_name)
    render json: { uoms: uoms.as_json(only: %i[id short_name]) }
  end

  private

  def item
    @item ||= Item.find(params[:id])
  end
end
