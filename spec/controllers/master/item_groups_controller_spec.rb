require "rails_helper"

RSpec.describe Master::ItemGroupsController, type: :controller do
  let(:user)       { create(:user) }
  let(:item_group) { create(:item_group) }

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

    it "populates instance variable with an array of item groups" do
      sign_in user
      get :index
      expect(assigns(:item_groups)).to eq([item_group])
      expect(assigns(:item_groups).size).to eq(1)
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

    it "assigns a new item group to an instance variable" do
      sign_in user
      get :new, xhr: true, format: :js
      expect(assigns(:item_group)).to be_a_new(ItemGroup)
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
      get :edit, xhr: true, format: :js, params: { id: item_group.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: item_group.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested item group to an instance variable" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: item_group.id }
      expect(assigns(:item_group)).to eq(item_group)
    end

    it "render edit template" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: item_group.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    it "requires login" do
      sign_out user
      post :create, xhr: true, format: :js, params: { item_group: { name: "ItemGroup 1" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "saves the new item group in the database" do
        sign_in user
        expect {
          post :create, xhr: true, format: :js, params: { item_group: { name: "ItemGroup 1" }}
        }.to change(ItemGroup, :count).by(1)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { item_group: { name: "ItemGroup 1" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns a newly created but unsaved item group to an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { item_group: { name: "ItemGroup 1" }}
        expect(assigns(:item_group)).to be_a(ItemGroup)
        expect(assigns(:item_group)).to be_persisted
      end

      it "have success flash message" do
        sign_in user
        post :create, xhr: true, format: :js, params: { item_group: { name: "ItemGroup 1" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.created", name: "Item Group"))
      end

      it "redirects to item groups index page" do
        sign_in user
        post :create, xhr: true, format: :js, params: { item_group: { name: "ItemGroup 1" }}
        expect(response).to redirect_to(master_item_groups_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new item group in the database" do
        sign_in user
        expect{
          post :create, xhr: true, format: :js, params: { item_group: { name: "" }}
        }.not_to change(ItemGroup, :count)
      end

      it "assigns a newly created but unsaved item group an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { item_group: { name: "" }}
        expect(assigns(:item_group)).to be_a_new(ItemGroup)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { item_group: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :new template" do
        sign_in user
        post :create, xhr: true, format: :js, params: { item_group: { name: "" }}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    it "requires login" do
      sign_out user
      patch :update, xhr: true, format: :js, params: { id: item_group.id, item_group: { name: "ItemGroup KFC" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "updates the requested item group" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: item_group.id, item_group: { name: "ItemGroup LG" }}
        item_group.reload
        expect(item_group.name).to eq("ItemGroup LG")
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: item_group.id, item_group: { name: "ItemGroup Nokia" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns the requested item group to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: item_group.id, item_group: { name: "ItemGroup MI" }}
        expect(assigns(:item_group)).to eq(item_group)
      end

      it "have success flash message" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: item_group.id, item_group: { name: "ItemGroup ZARA" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.updated", name: "Item Group"))
      end

      it "redirects to item group show page" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: item_group.id, item_group: { name: "ItemGroup MAC" }}
        expect(response).to redirect_to(master_item_groups_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the requested item group" do
        sign_in user
        expect {
          patch :update, xhr: true, format: :js, params: { id: item_group.id, item_group: { name: "" }}
        }.not_to change { item_group.reload.attributes }
      end

      it "assigns the item group to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: item_group.id, item_group: { name: "" }}
        expect(assigns(:item_group)).to eq(item_group)
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: item_group.id, item_group: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :edit template" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: item_group.id, item_group: { name: "" }}
        expect(response).to render_template(:edit)
      end
    end
  end
end
