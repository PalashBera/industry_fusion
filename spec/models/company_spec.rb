require "rails_helper"

RSpec.describe Company, type: :model do
  let(:user)    { create(:user) }
  let(:company) { create(:company) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "nameable"
  it_behaves_like "short_nameable"
  it_behaves_like "addressable"
  it_behaves_like "archivable"
  it_behaves_like "modal_formable"
  it_behaves_like "user_trackable"
  it_behaves_like "organization_associable"
  it_behaves_like "timestampble"

  describe "#associations" do
    it { should have_many(:warehouses) }
    it { should have_many(:indents) }
  end
end
