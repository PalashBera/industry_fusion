require "rails_helper"

RSpec.describe Admin::ApprovalLevels::IndentsController, type: :controller do
  let(:user)                  { create(:admin_user) }
  let(:indent_approval_level) { create(:approval_level, approval_type: "indents") }

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

    it "populates instance variable with an array of approval levels" do
      sign_in user
      get :index
      expect(assigns(:approval_levels)).to eq([indent_approval_level])
      expect(assigns(:approval_levels).size).to eq(1)
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
      get :new
      expect(response).to redirect_to(new_user_session_url)
    end

    it "returns http status 200" do
      sign_in user
      get :new
      expect(response).to have_http_status(:ok)
    end

    it "assigns a new indent approval level to an instance variable" do
      sign_in user
      get :new
      expect(assigns(:approval_level)).to be_a_new(ApprovalLevel)
    end

    it "render new template" do
      sign_in user
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "GET #edit" do
    it "requires login" do
      sign_out user
      get :edit, params: { id: indent_approval_level.id }
      expect(response).to have_http_status(302)
    end

    it "returns http status 200" do
      sign_in user
      get :edit, params: { id: indent_approval_level.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested indent approval level to an instance variable" do
      sign_in user
      get :edit, params: { id: indent_approval_level.id }
      expect(assigns(:approval_level)).to eq(indent_approval_level)
    end

    it "render edit template" do
      sign_in user
      get :edit, params: { id: indent_approval_level.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    it "requires login" do
      sign_out user
      post :create, params: { approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id }}}}
      expect(response).to have_http_status(302)
    end

    context "with valid attributes" do
      it "saves the new indent approval level in the database" do
        sign_in user
        expect {
          post :create, params: { approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id }}}}
        }.to change(ApprovalLevel, :count).by(1)
      end

      it "returns http status 302" do
        sign_in user
        post :create, params: { approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id }}}}
        expect(response).to have_http_status(302)
      end

      it "assigns a newly created but unsaved indent approval level to an instance variable" do
        sign_in user
        post :create, params: { approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id }}}}
        expect(assigns(:approval_level)).to be_a(ApprovalLevel)
        expect(assigns(:approval_level)).to be_persisted
      end

      it "have success flash message" do
        sign_in user
        post :create, params: { approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id }}}}
        expect(flash[:success]).to eq(I18n.t("flash_messages.created", name: "Indent approval level"))
      end

      it "redirects to indent approval levels index page" do
        sign_in user
        post :create, params: { approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id }}}}
        expect(response).to redirect_to(admin_approval_levels_indents_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new indent approval level in the database" do
        sign_in user
        expect{
          post :create, params: { approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id, _destroy: "false" }, "1": { user_id: user.id, _destroy: "false" }}}}
        }.not_to change(ApprovalLevel, :count)
      end

      it "assigns a newly created but unsaved indent approval level an instance variable" do
        sign_in user
        post :create, params: { approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id, _destroy: "false" }, "1": { user_id: user.id, _destroy: "false" }}}}
        expect(assigns(:approval_level)).to be_a_new(ApprovalLevel)
      end

      it "returns http status 200" do
        sign_in user
        post :create, params: { approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id, _destroy: "false" }, "1": { user_id: user.id, _destroy: "false" }}}}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :new template" do
        sign_in user
        post :create, params: { approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id, _destroy: "false" }, "1": { user_id: user.id, _destroy: "false" }}}}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    it "requires login" do
      sign_out user
      put :update, params: { id: indent_approval_level.id, approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id }}}}
      expect(response).to have_http_status(302)
    end

    context "with valid attributes" do
      it "updates the requested indent approval level" do
        sign_in user
        patch :update, params: { id: indent_approval_level.id, approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id }}}}
        indent_approval_level.reload
        expect(indent_approval_level.approval_type).to eq("indents")
      end

      it "returns http status 302" do
        sign_in user
        patch :update, params: { id: indent_approval_level.id, approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id }}}}
        expect(response).to have_http_status(302)
      end

      it "assigns the requested indent approval level to an instance variable" do
        sign_in user
        patch :update, params: { id: indent_approval_level.id, approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id }}}}
        expect(assigns(:approval_level)).to eq(indent_approval_level)
      end

      it "have success flash message" do
        sign_in user
        patch :update, params: { id: indent_approval_level.id, approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id }}}}
        expect(flash[:success]).to eq(I18n.t("flash_messages.updated", name: "Indent approval level"))
      end

      it "redirects to indent approval level index page" do
        sign_in user
        patch :update, params: { id: indent_approval_level.id, approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id }}}}
        expect(response).to redirect_to(admin_approval_levels_indents_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the requested approval" do
        sign_in user
        expect {
          patch :update, params: { id: indent_approval_level.id, approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id, _destroy: "false" }, "1": { user_id: user.id, _destroy: "false" }}}}
        }.not_to change { indent_approval_level.reload.attributes }
      end

      it "assigns the indent approval level to an instance variable" do
        sign_in user
        patch :update, params: { id: indent_approval_level.id, approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id, _destroy: "false" }, "1": { user_id: user.id, _destroy: "false" }}}}
        expect(assigns(:approval_level)).to eq(indent_approval_level)
      end

      it "returns http status 200" do
        sign_in user
        patch :update, params: { id: indent_approval_level.id, approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id, _destroy: "false" }, "1": { user_id: user.id, _destroy: "false" }}}}
        expect(response).to have_http_status(200)
      end

      it "re-renders the :edit template" do
        sign_in user
        patch :update, params: { id: indent_approval_level.id, approval_level: { approval_type: "indents", level_users_attributes: { "0": { user_id: user.id, _destroy: "false" }, "1": { user_id: user.id, _destroy: "false" }}}}
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:approval_level_1) { create :approval_level, approval_type: "indents" }

    it "requires login" do
      sign_out user
      delete :destroy, params: { id: indent_approval_level.id }
      expect(response).to redirect_to(new_user_session_url)
    end

    it "returns http status 302" do
      sign_in user
      delete :destroy, params: { id: indent_approval_level.id }
      expect(response).to have_http_status(302)
    end

    it "deletes the approval" do
      sign_in user
      expect{
        delete :destroy, params: { id: approval_level_1.id }
      }.to change(ApprovalLevel, :count).by(-1)
    end

    it "redirects to indent approval level index page" do
      sign_in user
      delete :destroy, params: { id: indent_approval_level.id }
      expect(response).to redirect_to(admin_approval_levels_indents_path)
    end
  end
end
