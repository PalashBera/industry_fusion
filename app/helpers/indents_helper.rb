module IndentsHelper
  def warehouse_options(object)
    Company.find_by(id: object.company_id)&.warehouses&.non_archived&.pluck(:name, :id).to_a
  end

  def make_options(object)
    Item.find_by(id: object.item_id)&.makes&.non_archived&.included_resources.to_a.map { |make| [make.brand_with_cat_no, make.id] }
  end

  def uom_options(object)
    Item.find_by(id: object.item_id)&.uoms.to_a.map { |uom| [uom.short_name, uom.id] }
  end

  def format_requirement_date(object)
    object.id.present? ? object.requirement_date.strftime("%d-%b-%Y") : ""
  end

  def priority_selection
    [%w[Default default], %w[High high], %w[Medium medium], %w[Low low]]
  end

  def fy_options
    initial_fy = current_organization.indents.initial_financial_year[0]
    current_fy = current_financial_year[1]
    fy_array = []
    year = current_fy

    while year > initial_fy
      fy_array << ["#{year - 1} - #{year}", "#{year - 1}-#{year}"]
      year -= 1
    end

    fy_array
  end
end
