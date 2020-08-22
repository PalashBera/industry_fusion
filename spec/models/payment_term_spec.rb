require "rails_helper"

RSpec.describe PaymentTerm, type: :model do
  let(:user)         { create(:user) }
  let(:payment_term) { create(:payment_term) }

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
    it { should have_db_column(:description) }
  end

  describe "#callbacks" do
    context "when name contains extra space" do
      it "should remove extra space" do
        payment_term = build(:payment_term, name: " Letter Of Credit  ")
        payment_term.valid?
        expect(payment_term.name).to eq ("Letter Of Credit")
      end
    end
  end

  describe "#validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:name).is_at_most(255) }

    context "when same Additional Term name present for an organization" do
      let!(:payment_term) { create(:payment_term, name: "Letter Of Credit") }

      it "should not save this Additional Term" do
        new_term = build(:payment_term, name: "Letter Of Credit")
        new_term.valid?
        expect(new_term.errors[:name]).to include("has already been taken")
      end
    end
  end

  describe "#scopes" do
    let!(:payment_term_1) { create(:payment_term, name: "Letter Of Credit 1", archive: true) }
    let!(:payment_term_2) { create(:payment_term, name: "Letter Of Credit 2", archive: false) }

    context "order_by_name" do
      it "should return terms order by name" do
        expect(PaymentTerm.order_by_name).to eq([payment_term_1, payment_term_2])
      end
    end
  end
end
