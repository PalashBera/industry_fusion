require "rails_helper"

RSpec.describe CostCenter, type: :model do
  let(:user)        { create(:user) }
  let(:cost_center) { create(:cost_center) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "nameable"
  it_behaves_like "archivable"
  it_behaves_like "modal_formable"
  it_behaves_like "user_trackable"
  it_behaves_like "organization_associable"
  it_behaves_like "timestampble"

  describe "#active_record_columns" do
    it { should have_db_column(:description) }
  end

  describe "#associations" do
    it { should have_many(:indent_items) }
  end
end
