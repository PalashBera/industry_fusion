require "rails_helper"

RSpec.describe Admin::WarehousesController, type: :controller do
  let(:user)      { create(:admin_user) }
  let(:company)   { create(:company) }
  let(:warehouse) { create(:warehouse) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  describe "GET index" do
    it "requires login" do
      sign_out user
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it "returns http status 200" do
      sign_in user
      get :index
      expect(response).to have_http_status(:ok)
    end

    it "populates instance variable with an array of warehouses" do
      sign_in user
      get :index
      expect(assigns(:warehouses)).to eq([warehouse])
      expect(assigns(:warehouses).size).to eq(1)
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

    it "assigns a new warehouse to an instance variable" do
      sign_in user
      get :new, xhr: true, format: :js
      expect(assigns(:warehouse)).to be_a_new(Warehouse)
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
      get :edit, xhr: true, format: :js, params: { id: warehouse.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: warehouse.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested warehouse to an instance variable" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: warehouse.id }
      expect(assigns(:warehouse)).to eq(warehouse)
    end

    it "render edit template" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: warehouse.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    it "requires login" do
      sign_out user
      post :create, xhr: true, format: :js, params: { warehouse: { name: "Company 1", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212", company_id: company.id }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "saves the new warehouse in the database" do
        sign_in user
        expect {
          post :create, xhr: true, format: :js, params: { warehouse: { name: "Company 1", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212", company_id: company.id }}
        }.to change(Warehouse, :count).by(1)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { warehouse: { name: "Company 1", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212", company_id: company.id }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns a newly created but unsaved warehouse to an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { warehouse: { name: "Company 1", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212", company_id: company.id }}
        expect(assigns(:warehouse)).to be_a(Warehouse)
        expect(assigns(:warehouse)).to be_persisted
      end

      it "have success flash message" do
        sign_in user
        post :create, xhr: true, format: :js, params: { warehouse: { name: "Company 1", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212", company_id: company.id }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.created", name: "Warehouse"))
      end

      it "redirects to warehouses index page" do
        sign_in user
        post :create, xhr: true, format: :js, params: { warehouse: { name: "Company 1", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212", company_id: company.id }}
        expect(response).to redirect_to(admin_warehouses_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new warehouse in the database" do
        sign_in user
        expect{
          post :create, xhr: true, format: :js, params: { warehouse: { name: "" }}
        }.not_to change(Warehouse, :count)
      end

      it "assigns a newly created but unsaved warehouse an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { warehouse: { name: "" }}
        expect(assigns(:warehouse)).to be_a_new(Warehouse)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { warehouse: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :new template" do
        sign_in user
        post :create, xhr: true, format: :js, params: { warehouse: { name: "" }}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    it "requires login" do
      sign_out user
      patch :update, xhr: true, format: :js, params: { id: warehouse.id, warehouse: { name: "Warehouse KFC" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "updates the requested warehouse" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: warehouse.id, warehouse: { name: "Warehouse LG" }}
        warehouse.reload
        expect(warehouse.name).to eq("Warehouse LG")
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: warehouse.id, warehouse: { name: "Warehouse Nokia" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns the requested warehouse to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: warehouse.id, warehouse: { name: "Warehouse MI" }}
        expect(assigns(:warehouse)).to eq(warehouse)
      end

      it "have success flash message" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: warehouse.id, warehouse: { name: "Warehouse ZARA" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.updated", name: "Warehouse"))
      end

      it "redirects to warehouse show page" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: warehouse.id, warehouse: { name: "Warehouse MAC" }}
        expect(response).to redirect_to(admin_warehouses_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the requested warehouse" do
        sign_in user
        expect {
          patch :update, xhr: true, format: :js, params: { id: warehouse.id, warehouse: { name: "" }}
        }.not_to change { warehouse.reload.attributes }
      end

      it "assigns the warehouse to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: warehouse.id, warehouse: { name: "" }}
        expect(assigns(:warehouse)).to eq(warehouse)
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: warehouse.id, warehouse: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :edit template" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: warehouse.id, warehouse: { name: "" }}
        expect(response).to render_template(:edit)
      end
    end
  end
end
