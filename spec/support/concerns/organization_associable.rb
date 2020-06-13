require "rails_helper"

shared_examples_for "organization_associable" do
  describe "#active_record_columns" do
    it { should have_db_column(:organization_id) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:organization_id) }
  end

  describe "#associations" do
    it { should belong_to(:organization).without_validating_presence }
  end
end
