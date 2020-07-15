class Master::ItemImagesController < Master::HomeController
  def index
    @images = ItemImage.item_filter(params[:item_id])
  end

  def destroy
    item_image = ItemImage.find(params[:id])
    item_image.destroy
    redirect_to master_items_path, flash: { success: t("flash_messages.deleted", name: "Item image") }
  end
end
