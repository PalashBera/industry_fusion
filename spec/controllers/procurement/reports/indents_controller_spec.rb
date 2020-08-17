require "rails_helper"

RSpec.describe Procurement::Reports::IndentsController, type: :controller do
  let(:user)      { create(:user) }

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

    it "populates instance variables" do
      sign_in user
      get :index
      expect(assigns(:item_names).nil?).to eq(false)
      expect(assigns(:item_wise_indent_items).nil?).to eq(false)
      expect(assigns(:cost_center_names).nil?).to eq(false)
      expect(assigns(:cost_center_wise_indent_items).nil?).to eq(false)
    end

    it "render index template" do
      sign_in user
      get :index
      expect(response).to render_template(:index)
    end
  end
end
