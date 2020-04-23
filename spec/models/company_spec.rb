require "rails_helper"

RSpec.describe Company, type: :model do
  let(:organization) { create(:organization) }
  let!(:company)     { create(:company, name: "Industry Fusion", organization: organization) }

  it_behaves_like "modal_formable"
  it_behaves_like "archivable"
  it_behaves_like "nameable"
  it_behaves_like "addressable"

  describe "active record columns" do
    it { should have_db_column(:organization_id) }
    it { should have_db_column(:created_by_id) }
    it { should have_db_column(:updated_by_id) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }
    it { should have_db_column(:short_name) }
  end

  describe "active record index" do
    it { should have_db_index(:organization_id) }
    it { should have_db_index(:created_by_id) }
    it { should have_db_index(:updated_by_id) }
  end

  describe "associations" do
    it { should belong_to(:organization) }
    it { should have_many(:warehouses) }
  end

  describe "validations" do
    it { should validate_presence_of(:short_name) }
    it { should validate_length_of(:short_name).is_at_most(8) }
    it { should validate_uniqueness_of(:short_name).case_insensitive.scoped_to(:organization_id) }
  end
end
