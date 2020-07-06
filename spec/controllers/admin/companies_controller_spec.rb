require "rails_helper"

RSpec.describe Admin::CompaniesController, type: :controller do
  let(:user)    { create(:admin_user) }
  let(:company) { create(:company) }

  before(:each) do
    @request.host = "#{user.organization.subdomain}.example.com"
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
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

    it "populates instance variable with an array of companies" do
      sign_in user
      get :index
      expect(assigns(:companies)).to eq([company])
      expect(assigns(:companies).size).to eq(1)
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

    it "assigns a new company to an instance variable" do
      sign_in user
      get :new, xhr: true, format: :js
      expect(assigns(:company)).to be_a_new(Company)
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
      get :edit, xhr: true, format: :js, params: { id: company.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: company.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested company to an instance variable" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: company.id }
      expect(assigns(:company)).to eq(company)
    end

    it "render edit template" do
      sign_in user
      get :edit, xhr: true, format: :js, params: { id: company.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    it "requires login" do
      sign_out user
      post :create, xhr: true, format: :js, params: { company: { name: "Company 1", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      logo = fixture_file_upload(Rails.root.join("spec", "fixtures", "images", "missing_image.jpg"), "image/jpg")

      it "saves the new company in the database" do
        sign_in user
        expect {
          post :create, xhr: true, format: :js, params: { company: { name: "Company 1", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212", logo: logo }}
        }.to change(Company, :count).by(1)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { company: { name: "Company 1", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212", logo: logo }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns a newly created but unsaved company to an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { company: { name: "Company 1", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212" }}
        expect(assigns(:company)).to be_a(Company)
        expect(assigns(:company)).to be_persisted
      end

      it "have success flash message" do
        sign_in user
        post :create, xhr: true, format: :js, params: { company: { name: "Company 1", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.created", name: "Company"))
      end

      it "redirects to companies index page" do
        sign_in user
        post :create, xhr: true, format: :js, params: { company: { name: "Company 1", short_name: "CMP", address1: "Demo", state: "Demo", city: "Demo", country: "Demo", pin_code: "121212", logo: logo }}
        expect(response).to redirect_to(admin_companies_path)
      end
    end

    context "with invalid attributes" do
      it "does not save the new company in the database" do
        sign_in user
        expect{
          post :create, xhr: true, format: :js, params: { company: { name: "" }}
        }.not_to change(Company, :count)
      end

      it "assigns a newly created but unsaved company an instance variable" do
        sign_in user
        post :create, xhr: true, format: :js, params: { company: { name: "" }}
        expect(assigns(:company)).to be_a_new(Company)
      end

      it "returns http status 200" do
        sign_in user
        post :create, xhr: true, format: :js, params: { company: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :new template" do
        sign_in user
        post :create, xhr: true, format: :js, params: { company: { name: "" }}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    it "requires login" do
      sign_out user
      patch :update, xhr: true, format: :js, params: { id: company.id, company: { name: "Company KFC" }}
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid attributes" do
      it "updates the requested company" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: company.id, company: { name: "Company LG" }}
        company.reload
        expect(company.name).to eq("Company LG")
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: company.id, company: { name: "Company Nokia" }}
        expect(response).to have_http_status(:ok)
      end

      it "assigns the requested company to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: company.id, company: { name: "Company MI" }}
        expect(assigns(:company)).to eq(company)
      end

      it "have success flash message" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: company.id, company: { name: "Company ZARA" }}
        expect(flash[:success]).to eq(I18n.t("flash_messages.updated", name: "Company"))
      end

      it "redirects to company show page" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: company.id, company: { name: "Company MAC" }}
        expect(response).to redirect_to(admin_companies_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the requested company" do
        sign_in user
        expect {
          patch :update, xhr: true, format: :js, params: { id: company.id, company: { name: "" }}
        }.not_to change { company.reload.attributes }
      end

      it "assigns the company to an instance variable" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: company.id, company: { name: "" }}
        expect(assigns(:company)).to eq(company)
      end

      it "returns http status 200" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: company.id, company: { name: "" }}
        expect(response).to have_http_status(:ok)
      end

      it "re-renders the :edit template" do
        sign_in user
        patch :update, xhr: true, format: :js, params: { id: company.id, company: { name: "" }}
        expect(response).to render_template(:edit)
      end
    end
  end
end
