require "rails_helper"

shared_examples_for "timestamp_module" do
  describe "#active_record_columns" do
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }
  end
end
