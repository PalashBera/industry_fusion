module IndentsHelper
  def company_dropdown_list(object)
    companies = Company.warehouse_filter(accessible_warehouse_ids).non_archived
    dropdown_list = companies.pluck(:name, :id)
    return dropdown_list unless object.company_id

    unless companies.pluck(:id).include?(object.company_id)
      selected_company = Company.find(object.company_id)
      dropdown_list = [[selected_company.name, selected_company.id]].concat(dropdown_list)
    end

    dropdown_list
  end

  def warehouse_dropdown_list(object)
    return [] unless object.company_id

    warehouses = Warehouse.id_filter(accessible_warehouse_ids).company_filter(object.company_id).non_archived.order_by_name
    dropdown_list = warehouses.pluck(:name, :id)

    unless warehouses.pluck(:id).include?(object.warehouse_id)
      selected_warehouse = Warehouse.find(object.warehouse_id)
      dropdown_list = [[selected_warehouse.name, selected_warehouse.id]].concat(dropdown_list)
    end

    dropdown_list
  end

  def indentor_dropdown_list(object)
    indentors = Indentor.non_archived.order_by_name
    dropdown_list = indentors.pluck(:name, :id)
    return dropdown_list unless object.indentor_id

    if object.indentor_id && !indentors.pluck(:id).include?(object.indentor_id)
      selected_indentor = Indentor.find(object.indentor_id)
      dropdown_list = [[selected_indentor.name, selected_indentor.id]].concat(dropdown_list)
    end

    dropdown_list
  end

  def item_dropdown_list(object)
    items = Item.non_archived.order_by_name
    dropdown_list = items.pluck(:name, :id)
    return dropdown_list unless object.item_id

    unless items.pluck(:id).include?(object.item_id)
      selected_item = Item.find(object.item_id)
      dropdown_list = [[selected_item.name, selected_item.id]].concat(dropdown_list)
    end

    dropdown_list
  end

  def make_dropdown_list(object)
    return [] unless object.item_id

    makes = Make.item_filter(object.item_id).non_archived.included_resources
    dropdown_list = makes.map { |make| [make.brand_with_cat_no, make.id] }

    if object.make_id && !makes.pluck(:id).include?(object.make_id)
      selected_make = Make.find(object.make_id)
      dropdown_list = [[selected_make.brand_with_cat_no, selected_make.id]].concat(dropdown_list)
    end

    dropdown_list
  end

  def uom_dropdown_list(object)
    return [] unless object.item_id

    Item.find_by(id: object.item_id).uoms.map { |uom| [uom.short_name, uom.id] }
  end

  def cost_center_dropdown_list(object)
    cost_centers = CostCenter.non_archived.order_by_name
    dropdown_list = cost_centers.pluck(:name, :id)
    return dropdown_list unless object.cost_center_id

    unless cost_centers.pluck(:id).include?(object.cost_center_id)
      selected_cost_center = CostCenter.find(object.cost_center_id)
      dropdown_list = [[selected_cost_center.name, selected_cost_center.id]].concat(dropdown_list)
    end

    dropdown_list
  end

  def border_bottom_attached?(item_ids, item_id)
    item_ids.include?(item_id) && item_ids.last != item_id
  end

  def add_active_class(indent_item)
    "text-info" if indent_item.note?
  end

  def note_input_title(indent_item)
    indent_item.note? ? "Edit note" : "Add note"
  end

  def indenx_note_link(indent_item)
    indent_item.note? ? active_note_display_link(indent_item) : disabled_note_display_link
  end

  def req_date_gt
    params[:q][:requirement_date_gteq]&.to_date if params[:q].present?
  end

  def req_date_lt
    params[:q][:requirement_date_lteq]&.to_date if params[:q].present?
  end
end
