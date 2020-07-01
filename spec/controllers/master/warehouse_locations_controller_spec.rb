require "rails_helper"

RSpec.describe Master::WarehouseLocationsController, type: :controller do
  let(:user)               { create(:user) }
  let(:warehouse)          { create(:warehouse) }
  let(:warehouse_location) { create(:warehouse_location) }

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

    it "populates instance variable with an array of warehouse_locations" do
      sign_in user
      get :index
      expect(assigns(:warehouse_locations)).to eq([warehouse_location])
      expect(assigns(:warehouse_locations).size).to eq(1)
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

    it "assigns a new warehouse location to an instance variable" do
      sign_in user
      get :new, xhr: true, format: :js
      expect(assigns(:warehouse_location)).to be_a_new(WarehouseLocation)
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
      get :edit, xhr: true, format: :js, params: { id: warehouse_location.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: warehouse_location.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested warehouse location to an instance variable" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: warehouse_location.id }
      expect(assigns(:warehouse_location)).to eq(warehouse_location)
    end

    it "render edit template" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: warehouse_location.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    it "requires login" do
      sign_out user
      post :create, xhr: true, format: :js, params: { warehouse_location: { name: "Warehouse location 1", warehouse_id: warehouse.id }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "saves the new warehouse location in the database" do
        sign_in user
        expect {
          post :create, xhr: true, format: :js, params: { warehouse_location: { name: "Warehouse location 1", warehouse_id: warehouse.id }}
        }.to change(WarehouseLocation, :count).by(1)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { warehouse_location: { name: "Warehouse location 1", warehouse_id: warehouse.id }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns a newly created but unsaved warehouse location to an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { warehouse_location: { name: "Warehouse location 1", warehouse_id: warehouse.id }}
        expect(assigns(:warehouse_location)).to be_a(WarehouseLocation)
        expect(assigns(:warehouse_location)).to be_persisted
      end

      it "have success flash message" do
        sign_in user
        post :create, xhr: true, format: :js, params: { warehouse_location: { name: "Warehouse location 1", warehouse_id: warehouse.id }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.created", name: "Location"))
      end

      it "redirects to warehouse location index page" do
        sign_in user
        post :create, xhr: true, format: :js, params: { warehouse_location: { name: "Warehouse location 1", warehouse_id: warehouse.id }}
        expect(response).to redirect_to(master_warehouse_locations_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new warehouse location in the database" do
        sign_in user
        expect{
          post :create, xhr: true, format: :js, params: { warehouse_location: { name: "" }}
        }.not_to change(WarehouseLocation, :count)
      end

      it "assigns a newly created but unsaved warehouse location an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { warehouse_location: { name: "" }}
        expect(assigns(:warehouse_location)).to be_a_new(WarehouseLocation)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { warehouse_location: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :new template" do
        sign_in user
        post :create, xhr: true, format: :js, params: { warehouse_location: { name: "" }}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    it "requires login" do
      sign_out user
      patch :update, xhr: true, format: :js, params: { id: warehouse_location.id, warehouse_location: { name: "Warehouse location KFC" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "updates the requested warehouse location" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: warehouse_location.id, warehouse_location: { name: "Warehouse location LG" }}
        warehouse_location.reload
        expect(warehouse_location.name).to eq("Warehouse location LG")
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: warehouse_location.id, warehouse_location: { name: "Warehouse location Nokia" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns the requested warehouse location to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: warehouse_location.id, warehouse_location: { name: "Warehouse location MI" }}
        expect(assigns(:warehouse_location)).to eq(warehouse_location)
      end

      it "have success flash message" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: warehouse_location.id, warehouse_location: { name: "Warehouse location ZARA" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.updated", name: "Location"))
      end

      it "redirects to warehouse location show page" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: warehouse_location.id, warehouse_location: { name: "Warehouse location MAC" }}
        expect(response).to redirect_to(master_warehouse_locations_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the requested warehouse location" do
        sign_in user
        expect {
          patch :update, xhr: true, format: :js, params: { id: warehouse_location.id, warehouse_location: { name: "" }}
        }.not_to change { warehouse_location.reload.attributes }
      end

      it "assigns the warehouse location to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: warehouse_location.id, warehouse_location: { name: "" }}
        expect(assigns(:warehouse_location)).to eq(warehouse_location)
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: warehouse_location.id, warehouse_location: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :edit template" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: warehouse_location.id, warehouse_location: { name: "" }}
        expect(response).to render_template(:edit)
      end
    end
  end
end
