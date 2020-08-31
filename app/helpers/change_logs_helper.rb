module ChangeLogsHelper
  def display_item_name(item_id)
    Item.find(item_id).name
  end

  def display_uom_name(uom_id)
    Uom.find(uom_id).name
  end

  def display_cost_center_name(cost_center_id)
    CostCenter.find(cost_center_id).name
  end

  def display_make(make_id)
    Make.find_by_id(make_id)&.brand_with_cat_no
  end
end
