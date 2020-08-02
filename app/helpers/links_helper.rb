module LinksHelper
  def excel_export_btn(controller_name)
    link_to raw('<i class="fas fa-file-export"></i><span class="d-none d-md-inline-block ml-1">Export</span>'),
            url_for(controller: controller_name, action: "export", format: "xlsx", params: params.to_unsafe_h),
            title: "Export #{controller_name.humanize.titleize}",
            class: "btn btn-dark"
  end

  def remove_filter_btn(controller_name)
    link_to "Remove Filter", url_for(controller: controller_name, action: "index"), class: "btn btn-secondary"
  end

  def link_to_add_fields(form, association, path = "")
    new_object = form.object.public_send(association).klass.new
    id = new_object.object_id

    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      path.present? ? render(path, f: builder) : render(association.to_s.singularize + "_fields", f: builder)
    end

    link_to raw('<i class="mdi mdi-plus"></i> Add more'), "#", class: "add_fields", data: { id: id, fields: fields.gsub("/n", "") }
  end

  def link_to_remove_fields
    link_to raw('<i class="fas fa-times text-danger"></i>'), "#", title: "Remove Item", class: "remove_fields"
  end

  def new_link_btn(controller_name)
    link_to raw('<i class="fas fa-plus-circle"></i><span class="d-none d-md-inline-block ml-1">Add New</span>'),
            url_for(controller: controller_name, action: "new"),
            title: "Add New #{controller_name.singularize.humanize.titleize}",
            class: "btn btn-primary"
  end

  def new_link(controller_name)
    link_to "Add New",
            url_for(controller: controller_name, action: "new"),
            title: "Add New #{controller_name.singularize.humanize.titleize}"
  end

  def edit_link(controller_name, resource)
    link_to raw('<i class="mdi mdi-square-edit-outline"></i> Edit'),
            url_for(controller: controller_name, action: "edit", id: resource.id),
            title: "Edit #{controller_name.singularize.humanize.titleize}"
  end

  def delete_link(controller_name, resource)
    link_to raw('<i class="mdi mdi-delete"></i> Delete'),
            url_for(controller: controller_name, action: "destroy", id: resource.id),
            method: :delete,
            data: { confirm: "Are you sure you want to delete?" },
            title: "Delete #{controller_name.singularize.humanize.titleize}",
            class: "text-danger"
  end

  def show_images_link(item)
    link_to raw('<i class="mdi mdi-camera-image"></i> Images'),
            url_for(controller: "master/item_images", action: "index", item_id: item.id),
            remote: true,
            title: "Show Images",
            class: "text-secondary"
  end

  def delete_image_link(image)
    link_to raw('<i class="mdi mdi-close"></i>'),
            url_for(controller: "master/item_images", action: "destroy", id: image.id),
            method: :delete,
            data: { confirm: "Are you sure you want to delete the image?" },
            title: "Delete Image",
            class: "btn btn-danger btn-sm delete-image-btn"
  end
end
