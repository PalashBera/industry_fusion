require "rails_helper"

RSpec.describe AdditionalTerm, type: :model do
  let(:user)            { create(:user) }
  let(:additional_term) { create(:additional_term) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
  end

  it_behaves_like "archive_module"
  it_behaves_like "modal_form_module"
  it_behaves_like "user_tracking_module"
  it_behaves_like "organization_association_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:name) }
    it { should have_db_column(:conditions) }
  end

  describe "#callbacks" do
    context "when name contains extra space" do
      it "should remove extra space" do
        additional_term = build(:additional_term, name: " Legal Actions  ")
        additional_term.valid?
        expect(additional_term.name).to eq ("Legal Actions")
      end
    end
  end

  describe "#validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:conditions) }
    it { should validate_length_of(:name).is_at_most(255) }

    context "when same Additional Term name present for an organization" do
      let!(:additional_term) { create(:additional_term, name: "Legal Actions") }

      it "should not save this Additional Term" do
        new_term = build(:additional_term, name: "Legal Actions")
        new_term.valid?
        expect(new_term.errors[:name]).to include("has already been taken")
      end
    end
  end

  describe "#scopes" do
    let!(:additional_term_1) { create(:additional_term, name: "Legal Actions 1", archive: true) }
    let!(:additional_term_2) { create(:additional_term, name: "Legal Actions 2", archive: false) }

    context "order_by_name" do
      it "should return terms order by name" do
        expect(AdditionalTerm.order_by_name).to eq([additional_term_1, additional_term_2])
      end
    end
  end
end
