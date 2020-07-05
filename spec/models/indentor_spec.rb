require "rails_helper"

RSpec.describe Indentor, type: :model do
  let(:user)     { create(:user) }
  let(:indentor) { create(:indentor) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "archive_module"
  it_behaves_like "modal_form_module"
  it_behaves_like "user_tracking_module"
  it_behaves_like "organization_association_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:name) }
  end

  describe "#callbacks" do
    context "when name contains extra space" do
      it "should remove extra space" do
        indentor = build(:indentor, name: " KFC  ")
        indentor.valid?
        expect(indentor.name).to eq ("KFC")
      end
    end
  end

  describe "#associations" do
    it { should have_many(:indents) }
  end

  describe "#validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }

    context "when same indentor name present for an organization" do
      let!(:indentor) { create(:indentor, name: "Nokia") }

      it "should not save this indentor" do
        new_indentor = build(:indentor, name: "Nokia")
        new_indentor.valid?
        expect(new_indentor.errors[:name]).to include("has already been taken")
      end
    end
  end

  describe "#scopes" do
    let!(:indentor_1) { create(:indentor, name: "Name 1", archive: true) }
    let!(:indentor_2) { create(:indentor, name: "Name 2", archive: false) }

    context "order_by_name" do
      it "should return indentors order by name" do
        expect(Indentor.order_by_name).to eq([indentor_1, indentor_2])
      end
    end
  end
end
