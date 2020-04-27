module IndentsHelper
  def warehouse_options(object)
    Company.find_by(id: object.company_id)&.warehouses&.pluck(:name, :id).to_a
  end

  def make_options(object)
    Item.find_by(id: object.item_id)&.makes&.included_resources.to_a.map { |make| [make.brand_name, make.id] }
  end

  def uom_options(object)
    Item.find_by(id: object.item_id)&.uoms.to_a.map { |uom| [uom.short_name, uom.id] }
  end

  def format_requirement_date(object)
    object.id.present? ? object.requirement_date.strftime("%d-%b-%Y") : ""
  end
end
