require "rails_helper"

RSpec.describe Admin::OrganizationsController, type: :controller do
  let(:user)                 { create(:admin_user) }
  let(:current_organization) { user.organization }

  describe "GET #edit" do
    it "requires login" do
      sign_out user
      get :edit, params: { id: current_organization.id }
      expect(response).to have_http_status(:found)
    end

    it "returns http status 200" do
      sign_in user
      get :edit, params: { id: current_organization.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested organization to an instance variable" do
      sign_in user
      get :edit, params: { id: current_organization.id }
      expect(assigns(:organization)).to eq(current_organization)
    end

    it "render edit template" do
      sign_in user
      get :edit, params: { id: current_organization.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    it "requires login" do
      sign_out user
      patch :update, params: { id: current_organization.id, organization: { name: "Organization KFC" }}
      expect(response).to have_http_status(:found)
    end

    context "with valid attributes" do
      it "updates the requested organization" do
        sign_in user
        patch :update, params: { id: current_organization.id, organization: { name: "Organization LG" }}
        current_organization.reload
        expect(current_organization.name).to eq("Organization LG")
      end

      it "returns http status 200" do
        sign_in user
        patch :update, params: { id: current_organization.id, organization: { name: "Organization Nokia" }}
        expect(response).to have_http_status(:found)
      end

      it "assigns the requested organization to an instance variable" do
        sign_in user
        patch :update, params: { id: current_organization.id, organization: { name: "Organization MI" }}
        expect(assigns(:organization)).to eq(current_organization)
      end

      it "have success flash message" do
        sign_in user
        patch :update, params: { id: current_organization.id, organization: { name: "Organization ZARA" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.updated", name: "Organization"))
      end

      it "redirects to organization show page" do
        sign_in user
        patch :update, params: { id: current_organization.id, organization: { name: "Organization MAC" }}
        expect(response).to redirect_to(edit_admin_organization_path(current_organization))
      end
    end

    context "with invalid attributes" do
      it "does not update the requested organization" do
        sign_in user
        expect {
          patch :update, params: { id: current_organization.id, organization: { name: "" }}
        }.not_to change { current_organization.reload.attributes }
      end

      it "assigns the organization to an instance variable" do
        sign_in user
        patch :update, params: { id: current_organization.id, organization: { name: "" }}
        expect(assigns(:organization)).to eq(current_organization)
      end

      it "returns http status 200" do
        sign_in user
        patch :update, params: { id: current_organization.id, organization: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :edit template" do
        sign_in user
        patch :update, params: { id: current_organization.id, organization: { name: "" }}
        expect(response).to render_template(:edit)
      end
    end
  end
end
