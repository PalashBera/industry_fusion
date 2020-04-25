module IndentsHelper
  def warehouse_options(form)
    form.object.company_id.present? ? Company.find(form.object.company_id).warehouses.pluck(:name, :id) : []
  end

  def make_options(form)
    form.object.item_id.present? ? Item.find(form.object.item_id).makes.included_resources.map { |make| [make.display, make.id] } : []
  end

  def uom_options(form)
    form.object.item_id.present? ? Item.find(form.object.item_id).uoms_list.map { |uom| [uom.short_name, uom.id] } : []
  end
end
