require "rails_helper"

RSpec.describe Master::ItemsController, type: :controller do
  let(:user)       { create(:user) }
  let(:uom)        { create(:uom) }
  let(:item_group) { create(:item_group) }
  let(:item)       { create(:item) }

  before(:each) do
    @request.host = "#{user.organization.subdomain}.example.com"
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  describe "GET index" do
    it "requires login" do
      sign_out user
      get :index
      expect(response).to redirect_to(new_user_session_url)
    end

    it "returns http status 200" do
      sign_in user
      get :index
      expect(response).to have_http_status(:ok)
    end

    it "populates instance variable with an array of items" do
      sign_in user
      get :index
      expect(assigns(:items)).to eq([item])
      expect(assigns(:items).size).to eq(1)
    end

    it "render index template" do
      sign_in user
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "requires login" do
      sign_out user
      get :new, xhr: true, format: :js
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :new, xhr: true, format: :js
      expect(response).to have_http_status(:ok)
    end

    it "assigns a new item to an instance variable" do
      sign_in user
      get :new, xhr: true, format: :js
      expect(assigns(:item)).to be_a_new(Item)
    end

    it "render new template" do
      sign_in user
      get :new, xhr: true, format: :js
      expect(response).to render_template(:new)
    end
  end

  describe "GET #edit" do
    it "requires login" do
      sign_out user
      get :edit, xhr: true, format: :js, params: { id: item.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: item.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested item to an instance variable" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: item.id }
      expect(assigns(:item)).to eq(item)
    end

    it "render edit template" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: item.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    image = fixture_file_upload(Rails.root.join("spec", "fixtures", "images", "missing_image.jpg"), "image/jpg")

    it "requires login" do
      sign_out user
      post :create, xhr: true, format: :js, params: { item: { name: "Item 1", item_group_id: item_group.id, uom_id: uom.id }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "saves the new item in the database" do
        sign_in user
        expect {
          post :create, xhr: true, format: :js, params: { item: { name: "Item 1", item_group_id: item_group.id, uom_id: uom.id }}
        }.to change(Item, :count).by(1)
      end

      it "creates item_image record" do
        sign_in user
        expect {
          post :create, xhr: true, format: :js, params: { item: { name: "Item 1", item_group_id: item_group.id, uom_id: uom.id, attachments: [image] }}
        }.to change(ItemImage, :count).by(1)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { item: { name: "Item 1", item_group_id: item_group.id, uom_id: uom.id }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns a newly created but unsaved item to an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { item: { name: "Item 1", item_group_id: item_group.id, uom_id: uom.id }}
        expect(assigns(:item)).to be_a(Item)
        expect(assigns(:item)).to be_persisted
      end

      it "have success flash message" do
        sign_in user
        post :create, xhr: true, format: :js, params: { item: { name: "Item 1", item_group_id: item_group.id, uom_id: uom.id }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.created", name: "Item"))
      end

      it "redirects to items index page" do
        sign_in user
        post :create, xhr: true, format: :js, params: { item: { name: "Item 1", item_group_id: item_group.id, uom_id: uom.id }}
        expect(response).to redirect_to(master_items_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new item in the database" do
        sign_in user
        expect{
          post :create, xhr: true, format: :js, params: { item: { name: "" }}
        }.not_to change(Item, :count)
      end

      it "assigns a newly created but unsaved item an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { item: { name: "" }}
        expect(assigns(:item)).to be_a_new(Item)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { item: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :new template" do
        sign_in user
        post :create, xhr: true, format: :js, params: { item: { name: "" }}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    image = fixture_file_upload(Rails.root.join("spec", "fixtures", "images", "missing_image.jpg"), "image/jpg")

    it "requires login" do
      sign_out user
      patch :update, xhr: true, format: :js, params: { id: item.id, item: { name: "Item KFC" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "updates the requested item" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: item.id, item: { name: "Item LG" }}
        item.reload
        expect(item.name).to eq("Item LG")
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: item.id, item: { name: "Item Nokia" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns the requested item to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: item.id, item: { name: "Item MI" }}
        expect(assigns(:item)).to eq(item)
      end

      it "have success flash message" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: item.id, item: { name: "Item ZARA" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.updated", name: "Item"))
      end

      it "redirects to item show page" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: item.id, item: { name: "Item MAC" }}
        expect(response).to redirect_to(master_items_path)
      end

      it "creates item_image record" do
        sign_in user
        expect {
          patch :update, xhr: true, format: :js, params: { id: item.id, item: { attachments: [image] }}
        }.to change(ItemImage, :count).by(1)
      end
    end

    context "with invalid attributes" do
      it "does not update the requested item" do
        sign_in user
        expect {
          patch :update, xhr: true, format: :js, params: { id: item.id, item: { name: "" }}
        }.not_to change { item.reload.attributes }
      end

      it "assigns the item to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: item.id, item: { name: "" }}
        expect(assigns(:item)).to eq(item)
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: item.id, item: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :edit template" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: item.id, item: { name: "" }}
        expect(response).to render_template(:edit)
      end
    end
  end
end
