require "rails_helper"

RSpec.describe Vendorship, type: :model do
  let(:user)       { create(:user) }
  let(:vendorship) { create(:vendorship) }

  before(:each) do
    Organization.current_organization = user.organization
    User.current_user = user
  end

  it_behaves_like "archivable"
  it_behaves_like "modal_formable"
  it_behaves_like "user_trackable"
  it_behaves_like "organization_associable"
  it_behaves_like "timestampble"

  describe "#active_record_columns" do
    it { should have_db_column(:vendor_id) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:vendor_id) }
    it { should have_db_index([:organization_id, :vendor_id]) }
  end

  describe "#associations" do
    it { should belong_to(:organization) }
    it { should belong_to(:vendor) }
  end

  describe "#validations" do
    let!(:vendorship) { create(:vendorship) }

    it { should validate_uniqueness_of(:vendor_id).scoped_to(:organization_id) }
  end
end
