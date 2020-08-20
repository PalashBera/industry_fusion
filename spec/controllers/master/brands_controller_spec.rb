require "rails_helper"

RSpec.describe Master::BrandsController, type: :controller do
  let(:user)  { create(:user) }
  let(:brand) { create(:brand) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
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

    it "populates instance variable with an array of brands" do
      sign_in user
      get :index
      expect(assigns(:brands)).to eq([brand])
      expect(assigns(:brands).size).to eq(1)
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

    it "assigns a new brand to an instance variable" do
      sign_in user
      get :new, xhr: true, format: :js
      expect(assigns(:brand)).to be_a_new(Brand)
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
      get :edit, xhr: true, format: :js, params: { id: brand.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: brand.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested brand to an instance variable" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: brand.id }
      expect(assigns(:brand)).to eq(brand)
    end

    it "render edit template" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: brand.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    it "requires login" do
      sign_out user
      post :create, xhr: true, format: :js, params: { brand: { name: "Brand 1" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "saves the new brand in the database" do
        sign_in user
        expect {
          post :create, xhr: true, format: :js, params: { brand: { name: "Brand 1" }}
        }.to change(Brand, :count).by(1)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { brand: { name: "Brand 1" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns a newly created but unsaved brand to an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { brand: { name: "Brand 1" }}
        expect(assigns(:brand)).to be_a(Brand)
        expect(assigns(:brand)).to be_persisted
      end

      it "have success flash message" do
        sign_in user
        post :create, xhr: true, format: :js, params: { brand: { name: "Brand 1" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.created", name: "Brand"))
      end

      it "redirects to brands index page" do
        sign_in user
        post :create, xhr: true, format: :js, params: { brand: { name: "Brand 1" }}
        expect(response).to redirect_to(master_brands_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new brand in the database" do
        sign_in user
        expect{
          post :create, xhr: true, format: :js, params: { brand: { name: "" }}
        }.not_to change(Brand, :count)
      end

      it "assigns a newly created but unsaved brand an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { brand: { name: "" }}
        expect(assigns(:brand)).to be_a_new(Brand)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { brand: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :new template" do
        sign_in user
        post :create, xhr: true, format: :js, params: { brand: { name: "" }}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    it "requires login" do
      sign_out user
      patch :update, xhr: true, format: :js, params: { id: brand.id, brand: { name: "Brand KFC" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "updates the requested brand" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: brand.id, brand: { name: "Brand LG" }}
        brand.reload
        expect(brand.name).to eq("Brand LG")
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: brand.id, brand: { name: "Brand Nokia" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns the requested brand to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: brand.id, brand: { name: "Brand MI" }}
        expect(assigns(:brand)).to eq(brand)
      end

      it "have success flash message" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: brand.id, brand: { name: "Brand ZARA" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.updated", name: "Brand"))
      end

      it "redirects to brand show page" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: brand.id, brand: { name: "Brand MAC" }}
        expect(response).to redirect_to(master_brands_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the requested brand" do
        sign_in user
        expect {
          patch :update, xhr: true, format: :js, params: { id: brand.id, brand: { name: "" }}
        }.not_to change { brand.reload.attributes }
      end

      it "assigns the brand to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: brand.id, brand: { name: "" }}
        expect(assigns(:brand)).to eq(brand)
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: brand.id, brand: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :edit template" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: brand.id, brand: { name: "" }}
        expect(response).to render_template(:edit)
      end
    end
  end
end
