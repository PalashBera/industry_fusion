require "rails_helper"

RSpec.describe Procurement::Indents::IndentItemsController, type: :controller do
  let(:user)        { create(:user) }
  let(:indent_item) { create(:indent_item) }

  before(:each) do

    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  describe "GET show" do
    it "requires login" do
      sign_out user
      get :show, xhr: true, format: :js, params: { id: indent_item.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http status 200" do
      sign_in user
      get :show, xhr: true, format: :js, params: { id: indent_item.id }
      expect(response).to have_http_status(:ok)
    end

    it "assigns the requested indent item to an instance variable" do
      sign_in user
      get :show, xhr: true, format: :js, params: { id: indent_item.id }
      expect(assigns(:indent_item)).to eq(indent_item)
    end

    it "render show template" do
      sign_in user
      get :show, xhr: true, format: :js, params: { id: indent_item.id }
      expect(response).to render_template(:show)
    end
  end
end
