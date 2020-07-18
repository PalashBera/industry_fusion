require "rails_helper"

RSpec.describe Master::ReorderLevelsController, type: :controller do
  let(:user)          { create(:user) }
  let(:warehouse)     { create(:warehouse) }
  let(:item)          { create(:item) }
  let(:reorder_level) { create(:reorder_level) }

  before(:each) do
    @request.host = "#{user.organization.subdomain}.example.com"
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "export_module"

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

    it "populates instance variable with an array of reorder_levels" do
      sign_in user
      get :index
      expect(assigns(:reorder_levels)).to eq([reorder_level])
      expect(assigns(:reorder_levels).size).to eq(1)
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

    it "assigns a new reorder level to an instance variable" do
      sign_in user
      get :new, xhr: true, format: :js
      expect(assigns(:reorder_level)).to be_a_new(ReorderLevel)
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
      get :edit, xhr: true, format: :js, params: { id: reorder_level.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: reorder_level.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested reorder level to an instance variable" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: reorder_level.id }
      expect(assigns(:reorder_level)).to eq(reorder_level)
    end

    it "render edit template" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: reorder_level.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    it "requires login" do
      sign_out user
      post :create, xhr: true, format: :js, params: { reorder_level: { warehouse_id: warehouse.id, item_id: item.id, quantity: rand(1..100), priority: "default" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "saves the new reorder level in the database" do
        sign_in user
        expect {
          post :create, xhr: true, format: :js, params: { reorder_level: { warehouse_id: warehouse.id, item_id: item.id, quantity: rand(1..100), priority: "default" }}
        }.to change(ReorderLevel, :count).by(1)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { reorder_level: { warehouse_id: warehouse.id, item_id: item.id, quantity: rand(1..100), priority: "default" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns a newly created but unsaved reorder level to an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { reorder_level: { warehouse_id: warehouse.id, item_id: item.id, quantity: rand(1..100), priority: "default" }}
        expect(assigns(:reorder_level)).to be_a(ReorderLevel)
        expect(assigns(:reorder_level)).to be_persisted
      end

      it "have success flash message" do
        sign_in user
        post :create, xhr: true, format: :js, params: { reorder_level: { warehouse_id: warehouse.id, item_id: item.id, quantity: rand(1..100), priority: "default" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.created", name: "Reorder level"))
      end

      it "redirects to reorder level index page" do
        sign_in user
        post :create, xhr: true, format: :js, params: { reorder_level: { warehouse_id: warehouse.id, item_id: item.id, quantity: rand(1..100), priority: "default" }}
        expect(response).to redirect_to(master_reorder_levels_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new reorder level in the database" do
        sign_in user
        expect{
          post :create, xhr: true, format: :js, params: { reorder_level: { quantity: 0 }}
        }.not_to change(ReorderLevel, :count)
      end

      it "assigns a newly created but unsaved reorder level an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { reorder_level: { quantity: 0 }}
        expect(assigns(:reorder_level)).to be_a_new(ReorderLevel)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { reorder_level: { quantity: 0 }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :new template" do
        sign_in user
        post :create, xhr: true, format: :js, params: { reorder_level: { quantity: 0 }}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    it "requires login" do
      sign_out user
      patch :update, xhr: true, format: :js, params: { id: reorder_level.id, reorder_level: { name: "ReorderLevel KFC" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "updates the requested reorder level" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: reorder_level.id, reorder_level: { quantity: 100 }}
        reorder_level.reload
        expect(reorder_level.quantity).to eq(100)
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: reorder_level.id, reorder_level: { quantity: 100 }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns the requested reorder level to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: reorder_level.id, reorder_level: { quantity: 100 }}
        expect(assigns(:reorder_level)).to eq(reorder_level)
      end

      it "have success flash message" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: reorder_level.id, reorder_level: { quantity: 100 }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.updated", name: "Reorder level"))
      end

      it "redirects to reorder level show page" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: reorder_level.id, reorder_level: { quantity: 100 }}
        expect(response).to redirect_to(master_reorder_levels_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the requested reorder level" do
        sign_in user
        expect {
          patch :update, xhr: true, format: :js, params: { id: reorder_level.id, reorder_level: { quantity: 0 }}
        }.not_to change { reorder_level.reload.attributes }
      end

      it "assigns the reorder level to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: reorder_level.id, reorder_level: { quantity: 0 }}
        expect(assigns(:reorder_level)).to eq(reorder_level)
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: reorder_level.id, reorder_level: { quantity: 0 }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :edit template" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: reorder_level.id, reorder_level: { quantity: 0 }}
        expect(response).to render_template(:edit)
      end
    end
  end
end
