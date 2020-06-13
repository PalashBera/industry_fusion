require "rails_helper"

RSpec.describe Master::UomsController, type: :controller do
  let(:user) { create(:user) }
  let(:uom)  { create(:uom) }

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

    it "populates instance variable with an array of uoms" do
      sign_in user
      get :index
      expect(assigns(:uoms)).to eq([uom])
      expect(assigns(:uoms).size).to eq(1)
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

    it "assigns a new uom to an instance variable" do
      sign_in user
      get :new, xhr: true, format: :js
      expect(assigns(:uom)).to be_a_new(Uom)
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
      get :edit, xhr: true, format: :js, params: { id: uom.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: uom.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested uom to an instance variable" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: uom.id }
      expect(assigns(:uom)).to eq(uom)
    end

    it "render edit template" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: uom.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    it "requires login" do
      sign_out user
      post :create, xhr: true, format: :js, params: { uom: { name: "Uom 1", short_name: "uom" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "saves the new uom in the database" do
        sign_in user
        expect {
          post :create, xhr: true, format: :js, params: { uom: { name: "Uom 1", short_name: "uom" }}
        }.to change(Uom, :count).by(1)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { uom: { name: "Uom 1", short_name: "uom" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns a newly created but unsaved uom to an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { uom: { name: "Uom 1", short_name: "uom" }}
        expect(assigns(:uom)).to be_a(Uom)
        expect(assigns(:uom)).to be_persisted
      end

      it "have success flash message" do
        sign_in user
        post :create, xhr: true, format: :js, params: { uom: { name: "Uom 1", short_name: "uom" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.created", name: "UOM"))
      end

      it "redirects to uoms index page" do
        sign_in user
        post :create, xhr: true, format: :js, params: { uom: { name: "Uom 1", short_name: "uom" }}
        expect(response).to redirect_to(master_uoms_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new uom in the database" do
        sign_in user
        expect{
          post :create, xhr: true, format: :js, params: { uom: { name: "" }}
        }.not_to change(Uom, :count)
      end

      it "assigns a newly created but unsaved uom an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { uom: { name: "" }}
        expect(assigns(:uom)).to be_a_new(Uom)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { uom: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :new template" do
        sign_in user
        post :create, xhr: true, format: :js, params: { uom: { name: "" }}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    it "requires login" do
      sign_out user
      patch :update, xhr: true, format: :js, params: { id: uom.id, uom: { name: "Uom KFC" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "updates the requested uom" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: uom.id, uom: { name: "Uom LG" }}
        uom.reload
        expect(uom.name).to eq("Uom LG")
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: uom.id, uom: { name: "Uom Nokia" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns the requested uom to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: uom.id, uom: { name: "Uom MI" }}
        expect(assigns(:uom)).to eq(uom)
      end

      it "have success flash message" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: uom.id, uom: { name: "Uom ZARA" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.updated", name: "UOM"))
      end

      it "redirects to uom show page" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: uom.id, uom: { name: "Uom MAC" }}
        expect(response).to redirect_to(master_uoms_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the requested uom" do
        sign_in user
        expect {
          patch :update, xhr: true, format: :js, params: { id: uom.id, uom: { name: "" }}
        }.not_to change { uom.reload.attributes }
      end

      it "assigns the uom to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: uom.id, uom: { name: "" }}
        expect(assigns(:uom)).to eq(uom)
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: uom.id, uom: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :edit template" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: uom.id, uom: { name: "" }}
        expect(response).to render_template(:edit)
      end
    end
  end
end
