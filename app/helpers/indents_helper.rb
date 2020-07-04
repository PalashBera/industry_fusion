module IndentsHelper
  def warehouse_options(object)
    return [] unless object.company_id

    Company.find_by(id: object.company_id).warehouses.non_archived.pluck(:name, :id)
  end

  def make_options(object)
    return [] unless object.item_id

    Item.find_by(id: object.item_id).makes.non_archived.included_resources.map { |make| [make.brand_with_cat_no, make.id] }
  end

  def uom_options(object)
    return [] unless object.item_id

    Item.find_by(id: object.item_id).uoms.map { |uom| [uom.short_name, uom.id] }
  end

  def format_requirement_date(object)
    object.id.present? ? object.requirement_date.strftime("%d-%b-%Y") : ""
  end

  def border_bottom_attached?(item_ids, item_id)
    item_ids.last != item_id && item_ids.include?(item_id)
  end

  def set_active_class(menu_item, current_tab)
    current_tab == menu_item ? "active" : ""
  end
end
