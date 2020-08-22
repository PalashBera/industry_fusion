require "rails_helper"

RSpec.describe Master::PaymentTermsController, type: :controller do
  let(:user)    { create(:user) }
  let(:payment_term) { create(:payment_term) }

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

    it "populates instance variable with an array of payment_terms" do
      sign_in user
      get :index
      expect(assigns(:payment_terms)).to eq([payment_term])
      expect(assigns(:payment_terms).size).to eq(1)
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

    it "assigns a new term to an instance variable" do
      sign_in user
      get :new, xhr: true, format: :js
      expect(assigns(:payment_term)).to be_a_new(PaymentTerm)
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
      get :edit, xhr: true, format: :js, params: { id: payment_term.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: payment_term.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested payment_term to an instance variable" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: payment_term.id }
      expect(assigns(:payment_term)).to eq(payment_term)
    end

    it "render edit template" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: payment_term.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    it "requires login" do
      sign_out user
      post :create, xhr: true, format: :js, params: { payment_term: { name: "Term 1", description: "abcd" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "saves the new payment_term in the database" do
        sign_in user
        expect {
          post :create, xhr: true, format: :js, params: { payment_term: { name: "Term 1", description: "abcd" }}
        }.to change(PaymentTerm, :count).by(1)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { payment_term: { name: "Payment Term 1", description: "abcd" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns a newly created but unsaved payment_term to an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { payment_term: { name: "Payment Term 1", description: "abcd" }}
        expect(assigns(:payment_term)).to be_a(PaymentTerm)
        expect(assigns(:payment_term)).to be_persisted
      end

      it "have success flash message" do
        sign_in user
        post :create, xhr: true, format: :js, params: { payment_term: { name: "Payment Term 1", description: "abcd" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.created", name: "Payment term"))
      end

      it "redirects to payment_terms index page" do
        sign_in user
        post :create, xhr: true, format: :js, params: { payment_term: { name: "Payment Term 1", description: "abcd" }}
        expect(response).to redirect_to(master_payment_terms_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new payment_term in the database" do
        sign_in user
        expect{
          post :create, xhr: true, format: :js, params: { payment_term: { name: "" }}
        }.not_to change(PaymentTerm, :count)
      end

      it "assigns a newly created but unsaved payment_term an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { payment_term: { name: "" }}
        expect(assigns(:payment_term)).to be_a_new(PaymentTerm)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { payment_term: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :new template" do
        sign_in user
        post :create, xhr: true, format: :js, params: { payment_term: { name: "" }}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    it "requires login" do
      sign_out user
      patch :update, xhr: true, format: :js, params: { id: payment_term.id, payment_term: { name: "Payment Term KFC" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "updates the requested payment_term" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: payment_term.id, payment_term: { name: "Payment Term LG" }}
        payment_term.reload
        expect(payment_term.name).to eq("Payment Term LG")
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: payment_term.id, payment_term: { name: "Payment Term Nokia" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns the requested payment_term to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: payment_term.id, payment_term: { name: "Payment Term MI" }}
        expect(assigns(:payment_term)).to eq(payment_term)
      end

      it "have success flash message" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: payment_term.id, payment_term: { name: "Payment Term ZARA" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.updated", name: "Payment term"))
      end

      it "redirects to payment_term show page" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: payment_term.id, payment_term: { name: "Payment Term MAC" }}
        expect(response).to redirect_to(master_payment_terms_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the requested payment_term" do
        sign_in user
        expect {
          patch :update, xhr: true, format: :js, params: { id: payment_term.id, payment_term: { name: "" }}
        }.not_to change { payment_term.reload.attributes }
      end

      it "assigns the payment_term to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: payment_term.id, payment_term: { name: "" }}
        expect(assigns(:payment_term)).to eq(payment_term)
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: payment_term.id, payment_term: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :edit template" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: payment_term.id, payment_term: { name: "" }}
        expect(response).to render_template(:edit)
      end
    end
  end
end
