require "rails_helper"

RSpec.describe Master::AdditionalTermsController, type: :controller do
  let(:user)            { create(:user) }
  let(:additional_term) { create(:additional_term) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
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

    it "populates instance variable with an array of additional_terms" do
      sign_in user
      get :index
      expect(assigns(:additional_terms)).to eq([additional_term])
      expect(assigns(:additional_terms).size).to eq(1)
    end

    it "render index template" do
      sign_in user
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    it "requires login" do
      sign_out user
      get :show, xhr: true, format: :js, params: { id: additional_term.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :show, xhr: true, format: :js, params: { id: additional_term.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested additional_term to an instance variable" do
      sign_in user
      get :show, xhr: true, format: :js, params: { id: additional_term.id }
      expect(assigns(:additional_term)).to eq(additional_term)
    end

    it "render show template" do
      sign_in user
      get :show, xhr: true, format: :js, params: { id: additional_term.id }
      expect(response).to render_template(:show)
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

    it "assigns a new term to an instance variable" do
      sign_in user
      get :new, xhr: true, format: :js
      expect(assigns(:additional_term)).to be_a_new(AdditionalTerm)
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
      get :edit, xhr: true, format: :js, params: { id: additional_term.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: additional_term.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested additional_term to an instance variable" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: additional_term.id }
      expect(assigns(:additional_term)).to eq(additional_term)
    end

    it "render edit template" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: additional_term.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    it "requires login" do
      sign_out user
      post :create, xhr: true, format: :js, params: { additional_term: { name: "Term 1", conditions: "abcd" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "saves the new additional_term in the database" do
        sign_in user
        expect {
          post :create, xhr: true, format: :js, params: { additional_term: { name: "Term 1", conditions: "abcd" }}
        }.to change(AdditionalTerm, :count).by(1)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { additional_term: { name: "Additional Term 1", conditions: "abcd" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns a newly created but unsaved additional_term to an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { additional_term: { name: "Additional Term 1", conditions: "abcd" }}
        expect(assigns(:additional_term)).to be_a(AdditionalTerm)
        expect(assigns(:additional_term)).to be_persisted
      end

      it "have success flash message" do
        sign_in user
        post :create, xhr: true, format: :js, params: { additional_term: { name: "Additional Term 1", conditions: "abcd" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.created", name: "Additional term"))
      end

      it "redirects to additional_terms index page" do
        sign_in user
        post :create, xhr: true, format: :js, params: { additional_term: { name: "Additional Term 1", conditions: "abcd" }}
        expect(response).to redirect_to(master_additional_terms_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new additional_term in the database" do
        sign_in user
        expect{
          post :create, xhr: true, format: :js, params: { additional_term: { name: "" }}
        }.not_to change(AdditionalTerm, :count)
      end

      it "assigns a newly created but unsaved additional_term an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { additional_term: { name: "" }}
        expect(assigns(:additional_term)).to be_a_new(AdditionalTerm)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { additional_term: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :new template" do
        sign_in user
        post :create, xhr: true, format: :js, params: { additional_term: { name: "" }}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    it "requires login" do
      sign_out user
      patch :update, xhr: true, format: :js, params: { id: additional_term.id, additional_term: { name: "Additional Term KFC" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "updates the requested additional_term" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: additional_term.id, additional_term: { name: "Additional Term LG" }}
        additional_term.reload
        expect(additional_term.name).to eq("Additional Term LG")
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: additional_term.id, additional_term: { name: "Additional Term Nokia" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns the requested additional_term to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: additional_term.id, additional_term: { name: "Additional Term MI" }}
        expect(assigns(:additional_term)).to eq(additional_term)
      end

      it "have success flash message" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: additional_term.id, additional_term: { name: "Additional Term ZARA" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.updated", name: "Additional term"))
      end

      it "redirects to additional_term show page" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: additional_term.id, additional_term: { name: "Additional Term MAC" }}
        expect(response).to redirect_to(master_additional_terms_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the requested additional_term" do
        sign_in user
        expect {
          patch :update, xhr: true, format: :js, params: { id: additional_term.id, additional_term: { name: "" }}
        }.not_to change { additional_term.reload.attributes }
      end

      it "assigns the additional_term to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: additional_term.id, additional_term: { name: "" }}
        expect(assigns(:additional_term)).to eq(additional_term)
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: additional_term.id, additional_term: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :edit template" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: additional_term.id, additional_term: { name: "" }}
        expect(response).to render_template(:edit)
      end
    end
  end
end
