require "rails_helper"

RSpec.describe Master::ItemImagesController, type: :controller do
  let(:user) { create(:user) }
  let(:item) { create(:item) }

  before(:each) do

    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  describe "GET index" do
    let(:image) { fixture_file_upload(Rails.root.join("spec", "fixtures", "images", "missing_image.jpg"), "image/jpg") }
    let!(:item_image) { create :item_image, image: image, item_id: item.id }

    it "requires login" do
      sign_out user
      get :index, xhr: true, format: :js, params: { item_id: item.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :index, xhr: true, format: :js, params: { item_id: item.id }
      expect(response).to have_http_status(:ok)
    end

    it "populates instance variable with an array of item images" do
      sign_in user
      get :index, xhr: true, format: :js, params: { item_id: item.id }
      expect(assigns(:images)).to eq([item_image])
      expect(assigns(:images).size).to eq(1)
    end
  end

  describe "DELETE #destroy" do
    let(:image)       { fixture_file_upload(Rails.root.join("spec", "fixtures", "images", "missing_image.jpg"), "image/jpg") }
    let!(:item_image) { create :item_image, image: image, item_id: item.id }

    it "deletes the item image" do
      sign_in user

      expect{
        delete :destroy, params:{ id: item_image.id }
      }.to change(ItemImage, :count).by(-1)

      expect(response).to redirect_to(master_items_path)
    end
  end
end
