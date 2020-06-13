require "rails_helper"

RSpec.describe OrganizationsController, type: :controller do
  let(:user)         { create(:user) }
  let(:organization) { create(:organization) }

  describe "GET #new" do
    it "requires login" do
      sign_out user
      get :new
      expect(response).to have_http_status(:found)
    end

    it "returns http status 200" do
      sign_in user
      get :new
      expect(response).to have_http_status(:ok)
    end

    it "assigns a new organization to an instance variable" do
      sign_in user
      get :new
      expect(assigns(:organization)).to be_a_new(Organization)
    end

    it "render new template" do
      sign_in user
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    it "requires login" do
      sign_out user
      post :create, params: { organization: { name: "Demo Org", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212", fy_start_month: 4, fy_end_month: 3 }}
      expect(response).to have_http_status(:found)
    end

    context "with valid attributes" do
      it "saves the new organization in the database" do
        sign_in user
        expect {
          post :create, params: { organization: { name: "Demo Org", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212", fy_start_month: 4, fy_end_month: 3 }}
        }.to change(Organization, :count).by(1)
      end

      it "returns http status 302" do
        sign_in user
        post :create, params: { organization: { name: "Demo Org", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212", fy_start_month: 4, fy_end_month: 3 }}
        expect(response).to have_http_status(:found)
      end

      it "assigns a newly created but unsaved organization to an instance variable" do
        sign_in user
        post :create, params: { organization: { name: "Demo Org", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212", fy_start_month: 4, fy_end_month: 3 }}
        expect(assigns(:organization)).to be_a(Organization)
        expect(assigns(:organization)).to be_persisted
      end

      it "have success flash message" do
        sign_in user
        post :create, params: { organization: { name: "Demo Org", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212", fy_start_month: 4, fy_end_month: 3 }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.created", name: "Organization"))
      end

      it "redirects to organizations index page" do
        sign_in user
        post :create, params: { organization: { name: "Demo Org", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212", fy_start_month: 4, fy_end_month: 3 }}
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new organization in the database" do
        sign_in user
        expect{
          post :create, params: { organization: { name: "" }}
        }.not_to change(Organization, :count)
      end

      it "assigns a newly created but unsaved organization an instance variable" do
        sign_in user
        post :create, params: { organization: { name: "" }}
        expect(assigns(:organization)).to be_a_new(Organization)
      end

      it "returns http status 200" do
        sign_in user
        post :create, params: { organization: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :new template" do
        sign_in user
        post :create, params: { organization: { name: "" }}
        expect(response).to render_template(:new)
      end
    end
  end
end
