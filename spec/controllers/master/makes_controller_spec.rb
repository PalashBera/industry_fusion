require "rails_helper"

RSpec.describe Master::MakesController, type: :controller do
  let(:user)  { create(:user) }
  let(:item)  { create(:item) }
  let(:brand) { create(:brand) }
  let(:make)  { create(:make) }

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

    it "populates instance variable with an array of makes" do
      sign_in user
      get :index
      expect(assigns(:makes)).to eq([make])
      expect(assigns(:makes).size).to eq(1)
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

    it "assigns a new make to an instance variable" do
      sign_in user
      get :new, xhr: true, format: :js
      expect(assigns(:make)).to be_a_new(Make)
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
      get :edit, xhr: true, format: :js, params: { id: make.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: make.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested make to an instance variable" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: make.id }
      expect(assigns(:make)).to eq(make)
    end

    it "render edit template" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: make.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    it "requires login" do
      sign_out user
      post :create, xhr: true, format: :js, params: { make: { item_id: item.id, brand_id: brand.id, cat_no: "1234" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "saves the new make in the database" do
        sign_in user
        expect {
          post :create, xhr: true, format: :js, params: { make: { item_id: item.id, brand_id: brand.id, cat_no: "1234" }}
        }.to change(Make, :count).by(1)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { make: { item_id: item.id, brand_id: brand.id, cat_no: "1234" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns a newly created but unsaved make to an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { make: { item_id: item.id, brand_id: brand.id, cat_no: "1234" }}
        expect(assigns(:make)).to be_a(Make)
        expect(assigns(:make)).to be_persisted
      end

      it "have success flash message" do
        sign_in user
        post :create, xhr: true, format: :js, params: { make: { item_id: item.id, brand_id: brand.id, cat_no: "1234" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.created", name: "Make"))
      end

      it "redirects to makes index page" do
        sign_in user
        post :create, xhr: true, format: :js, params: { make: { item_id: item.id, brand_id: brand.id, cat_no: "1234" }}
        expect(response).to redirect_to(master_makes_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new make in the database" do
        sign_in user
        expect{
          post :create, xhr: true, format: :js, params: { make: { item_id: nil }}
        }.not_to change(Make, :count)
      end

      it "assigns a newly created but unsaved make an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { make: { item_id: nil }}
        expect(assigns(:make)).to be_a_new(Make)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { make: { item_id: nil }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :new template" do
        sign_in user
        post :create, xhr: true, format: :js, params: { make: { item_id: nil }}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    it "requires login" do
      sign_out user
      patch :update, xhr: true, format: :js, params: { id: make.id, make: { cat_no: "Make KFC" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "updates the requested make" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: make.id, make: { cat_no: "Make LG" }}
        make.reload
        expect(make.cat_no).to eq("Make LG")
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: make.id, make: { cat_no: "Make Nokia" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns the requested make to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: make.id, make: { cat_no: "Make MI" }}
        expect(assigns(:make)).to eq(make)
      end

      it "have success flash message" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: make.id, make: { cat_no: "Make ZARA" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.updated", name: "Make"))
      end

      it "redirects to make show page" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: make.id, make: { cat_no: "Make MAC" }}
        expect(response).to redirect_to(master_makes_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the requested make" do
        sign_in user
        expect {
          patch :update, xhr: true, format: :js, params: { id: make.id, make: { item_id: nil }}
        }.not_to change { make.reload.attributes }
      end

      it "assigns the make to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: make.id, make: { item_id: nil }}
        expect(assigns(:make)).to eq(make)
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: make.id, make: { item_id: nil }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :edit template" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: make.id, make: { item_id: nil }}
        expect(response).to render_template(:edit)
      end
    end
  end
end
