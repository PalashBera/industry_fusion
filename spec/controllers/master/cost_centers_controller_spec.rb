require "rails_helper"

RSpec.describe Master::CostCentersController, type: :controller do
  let(:user)        { create(:user) }
  let(:cost_center) { create(:cost_center) }

  before(:each) do

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

    it "populates instance variable with an array of cost centers" do
      sign_in user
      get :index
      expect(assigns(:cost_centers)).to eq([cost_center])
      expect(assigns(:cost_centers).size).to eq(1)
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

    it "assigns a new cost center to an instance variable" do
      sign_in user
      get :new, xhr: true, format: :js
      expect(assigns(:cost_center)).to be_a_new(CostCenter)
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
      get :edit, xhr: true, format: :js, params: { id: cost_center.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: cost_center.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested cost center to an instance variable" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: cost_center.id }
      expect(assigns(:cost_center)).to eq(cost_center)
    end

    it "render edit template" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: cost_center.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    it "requires login" do
      sign_out user
      post :create, xhr: true, format: :js, params: { cost_center: { name: "CostCenter 1" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "saves the new cost center in the database" do
        sign_in user
        expect {
          post :create, xhr: true, format: :js, params: { cost_center: { name: "CostCenter 1" }}
        }.to change(CostCenter, :count).by(1)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { cost_center: { name: "CostCenter 1" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns a newly created but unsaved cost center to an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { cost_center: { name: "CostCenter 1" }}
        expect(assigns(:cost_center)).to be_a(CostCenter)
        expect(assigns(:cost_center)).to be_persisted
      end

      it "have success flash message" do
        sign_in user
        post :create, xhr: true, format: :js, params: { cost_center: { name: "CostCenter 1" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.created", name: "Cost Center"))
      end

      it "redirects to cost centers index page" do
        sign_in user
        post :create, xhr: true, format: :js, params: { cost_center: { name: "CostCenter 1" }}
        expect(response).to redirect_to(master_cost_centers_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new cost center in the database" do
        sign_in user
        expect{
          post :create, xhr: true, format: :js, params: { cost_center: { name: "" }}
        }.not_to change(CostCenter, :count)
      end

      it "assigns a newly created but unsaved cost center an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { cost_center: { name: "" }}
        expect(assigns(:cost_center)).to be_a_new(CostCenter)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { cost_center: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :new template" do
        sign_in user
        post :create, xhr: true, format: :js, params: { cost_center: { name: "" }}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    it "requires login" do
      sign_out user
      patch :update, xhr: true, format: :js, params: { id: cost_center.id, cost_center: { name: "CostCenter KFC" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "updates the requested cost center" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: cost_center.id, cost_center: { name: "CostCenter LG" }}
        cost_center.reload
        expect(cost_center.name).to eq("CostCenter LG")
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: cost_center.id, cost_center: { name: "CostCenter Nokia" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns the requested cost center to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: cost_center.id, cost_center: { name: "CostCenter MI" }}
        expect(assigns(:cost_center)).to eq(cost_center)
      end

      it "have success flash message" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: cost_center.id, cost_center: { name: "CostCenter ZARA" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.updated", name: "Cost Center"))
      end

      it "redirects to cost center show page" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: cost_center.id, cost_center: { name: "CostCenter MAC" }}
        expect(response).to redirect_to(master_cost_centers_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the requested cost center" do
        sign_in user
        expect {
          patch :update, xhr: true, format: :js, params: { id: cost_center.id, cost_center: { name: "" }}
        }.not_to change { cost_center.reload.attributes }
      end

      it "assigns the cost center to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: cost_center.id, cost_center: { name: "" }}
        expect(assigns(:cost_center)).to eq(cost_center)
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: cost_center.id, cost_center: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :edit template" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: cost_center.id, cost_center: { name: "" }}
        expect(response).to render_template(:edit)
      end
    end
  end
end
