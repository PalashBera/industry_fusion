require "rails_helper"

RSpec.describe Master::IndentorsController, type: :controller do
  let(:user)     { create(:user) }
  let(:indentor) { create(:indentor) }

  before(:each) do
    @request.host = "#{user.organization.subdomain}.example.com"
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

    it "populates instance variable with an array of indentors" do
      sign_in user
      get :index
      expect(assigns(:indentors)).to eq([indentor])
      expect(assigns(:indentors).size).to eq(1)
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

    it "assigns a new indentor to an instance variable" do
      sign_in user
      get :new, xhr: true, format: :js
      expect(assigns(:indentor)).to be_a_new(Indentor)
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
      get :edit, xhr: true, format: :js, params: { id: indentor.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: indentor.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested indentor to an instance variable" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: indentor.id }
      expect(assigns(:indentor)).to eq(indentor)
    end

    it "render edit template" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: indentor.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    it "requires login" do
      sign_out user
      post :create, xhr: true, format: :js, params: { indentor: { name: "Indentor 1" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "saves the new indentor in the database" do
        sign_in user
        expect {
          post :create, xhr: true, format: :js, params: { indentor: { name: "Indentor 1" }}
        }.to change(Indentor, :count).by(1)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { indentor: { name: "Indentor 1" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns a newly created but unsaved indentor to an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { indentor: { name: "Indentor 1" }}
        expect(assigns(:indentor)).to be_a(Indentor)
        expect(assigns(:indentor)).to be_persisted
      end

      it "have success flash message" do
        sign_in user
        post :create, xhr: true, format: :js, params: { indentor: { name: "Indentor 1" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.created", name: "Indentor"))
      end

      it "redirects to indentors index page" do
        sign_in user
        post :create, xhr: true, format: :js, params: { indentor: { name: "Indentor 1" }}
        expect(response).to redirect_to(master_indentors_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new indentor in the database" do
        sign_in user
        expect{
          post :create, xhr: true, format: :js, params: { indentor: { name: "" }}
        }.not_to change(Indentor, :count)
      end

      it "assigns a newly created but unsaved indentor an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { indentor: { name: "" }}
        expect(assigns(:indentor)).to be_a_new(Indentor)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { indentor: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :new template" do
        sign_in user
        post :create, xhr: true, format: :js, params: { indentor: { name: "" }}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    it "requires login" do
      sign_out user
      patch :update, xhr: true, format: :js, params: { id: indentor.id, indentor: { name: "Indentor KFC" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "updates the requested indentor" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: indentor.id, indentor: { name: "Indentor LG" }}
        indentor.reload
        expect(indentor.name).to eq("Indentor LG")
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: indentor.id, indentor: { name: "Indentor Nokia" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns the requested indentor to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: indentor.id, indentor: { name: "Indentor MI" }}
        expect(assigns(:indentor)).to eq(indentor)
      end

      it "have success flash message" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: indentor.id, indentor: { name: "Indentor ZARA" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.updated", name: "Indentor"))
      end

      it "redirects to indentor show page" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: indentor.id, indentor: { name: "Indentor MAC" }}
        expect(response).to redirect_to(master_indentors_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the requested indentor" do
        sign_in user
        expect {
          patch :update, xhr: true, format: :js, params: { id: indentor.id, indentor: { name: "" }}
        }.not_to change { indentor.reload.attributes }
      end

      it "assigns the indentor to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: indentor.id, indentor: { name: "" }}
        expect(assigns(:indentor)).to eq(indentor)
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: indentor.id, indentor: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :edit template" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: indentor.id, indentor: { name: "" }}
        expect(response).to render_template(:edit)
      end
    end
  end
end
