require "rails_helper"

RSpec.describe Indent, type: :model do
  let!(:indent)      { create(:indent) }

  describe "active record columns" do
    it { should have_db_column(:organization_id) }
    it { should have_db_column(:created_by_id) }
    it { should have_db_column(:updated_by_id) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }
    it { should have_db_column(:company_id) }
    it { should have_db_column(:warehouse_id) }
    it { should have_db_column(:requirement_date) }
  end

  describe "active record index" do
    it { should have_db_index(:organization_id) }
    it { should have_db_index(:company_id) }
    it { should have_db_index(:warehouse_id) }
    it { should have_db_index(:created_by_id) }
    it { should have_db_index(:updated_by_id) }
  end

  describe "associations" do
    it { should belong_to(:organization) }
    it { should belong_to(:company) }
    it { should belong_to(:warehouse) }

    it { should have_many(:indent_items) }
  end
end
