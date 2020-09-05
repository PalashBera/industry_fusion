module IndentsHelper
  def method_missing(method, *args, &block)
    if method.to_s =~ /^dropdown_list_\w+/
      self.class.__send__(:define_method, method) do |*args|
        method_definition(method, args)
      end

      __send__ method, *args, &block
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?("dropdown_list_") || super
  end

  def method_definition(method, args)
    klass_name = method.to_s.gsub(/^dropdown_list_/, "")
    obj, attribute = args
    klass_name_id = obj.public_send("#{klass_name}_id")
    build_dropdown_list(klass_name, klass_name_id, attribute, obj)
  end

  def fetch_entities(klass_name, obj)
    case klass_name
    when "company"
      Company.warehouse_filter(accessible_warehouse_ids).non_archived
    when "warehouse"
      Warehouse.id_filter(accessible_warehouse_ids).company_filter(obj.company_id).non_archived.order_by_name if obj.company_id
    when "make"
      Make.item_filter(obj.item_id).non_archived.included_resources if obj.item_id
    when "uom"
      Item.find_by(id: obj.item_id).uoms if obj.item_id
    else
      klass_name.camelize.constantize.non_archived.order_by_name
    end
  end

  def build_dropdown_list(klass_name, klass_name_id, attribute, obj)
    entities = fetch_entities(klass_name, obj) || []
    dropdown_list = entities.map { |ent| [ent.public_send(attribute), ent.id] }
    return dropdown_list unless klass_name_id

    unless entities.map(&:id).include?(klass_name_id)
      selected_entity = klass_name.camelize.constantize.find(klass_name_id)
      dropdown_list = [[selected_entity.public_send(attribute), selected_entity.id]].concat(dropdown_list)
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
