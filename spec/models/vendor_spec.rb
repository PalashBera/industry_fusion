require "rails_helper"

RSpec.describe Vendor, type: :model do
  it_behaves_like "user_information_module"
  it_behaves_like "modal_form_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:invitation_token) }
    it { should have_db_column(:invitation_created_at) }
    it { should have_db_column(:invitation_sent_at) }
    it { should have_db_column(:invitation_accepted_at) }
    it { should have_db_column(:invitation_limit) }
    it { should have_db_column(:invited_by_type) }
    it { should have_db_column(:invited_by_id) }
    it { should have_db_column(:invitations_count) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:invitation_token) }
    it { should have_db_index(:invitations_count) }
    it { should have_db_index([:invited_by_type, :invited_by_id]) }
  end

  describe "#associations" do
    it { should have_one(:store_information) }
    it { should have_many(:vendorships) }
    it { should have_many(:organizations) }
  end
end
