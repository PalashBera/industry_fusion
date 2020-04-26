module IndentsHelper
  def warehouse_options(object)
    object.company_id.present? ? Company.find(object.company_id).warehouses.pluck(:name, :id) : []
  end

  def make_options(object)
    object.item_id.present? ? Item.find(object.item_id).makes.included_resources.map { |make| [make.display, make.id] } : []
  end

  def uom_options(object)
    object.item_id.present? ? Item.find(object.item_id).uoms_list.map { |uom| [uom.short_name, uom.id] } : []
  end
end
