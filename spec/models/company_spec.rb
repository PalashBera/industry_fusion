require "rails_helper"

RSpec.describe Company, type: :model do
  let(:user)    { create(:user) }
  let(:company) { create(:company) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
  end

  it_behaves_like "address_module"
  it_behaves_like "archive_module"
  it_behaves_like "modal_form_module"
  it_behaves_like "user_tracking_module"
  it_behaves_like "organization_association_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:name) }
    it { should have_db_column(:short_name) }
  end

  describe "#callbacks" do
    context "when name contains extra space" do
      it "should remove extra space" do
        company = build(:company, name: " KFC  ")
        company.valid?
        expect(company.name).to eq ("KFC")
      end
    end

    context "when short name contains extra space" do
      it "should remove extra space" do
        company = build(:company, short_name: " SBC ")
        company.valid?
        expect(company.short_name).to eq ("SBC")
      end
    end

    context "when short name is not in upcase" do
      it "should make short name in upcase" do
        company = build(:company, short_name: " sbc ")
        company.valid?
        expect(company.short_name).to eq ("SBC")
      end
    end
  end

  describe "#associations" do
    it { should have_many(:warehouses) }
    it { should have_many(:indents) }
    it { should have_attached_file(:logo) }
  end

  describe "#validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:short_name) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_length_of(:short_name).is_at_most(3) }
    it { should validate_attachment_size(:logo).less_than(2.megabytes) }
    it { should validate_attachment_content_type(:logo).allowing("image/png", "image/jpeg") }

    context "when same company name and short name present for an organization" do
      let!(:company) { create(:company, name: "Nokia", short_name: "AAA") }

      it "should not save this company" do
        new_company = build(:company, name: "Nokia", short_name: "AAA")
        new_company.valid?
        expect(new_company.errors[:name]).to include("has already been taken")
        expect(new_company.errors[:short_name]).to include("has already been taken")
      end
    end
  end

  describe "#scopes" do
    let!(:company_1)   { create(:company, name: "Name 1", archive: true) }
    let!(:company_2)   { create(:company, name: "Name 2", archive: false) }
    let!(:warehouse_1) { create :warehouse, company_id: company_1.id }
    let!(:warehouse_2) { create :warehouse, company_id: company_2.id }

    context "order_by_name" do
      it "should return companies order by name" do
        expect(Company.order_by_name).to eq([company_1, company_2])
      end
    end

    context "#warehouse_filter" do
      it "should return companies which has some specific warehouses" do
        expect(Company.warehouse_filter(warehouse_1.id).include?(company_1)).to eq(true)
        expect(Company.warehouse_filter(warehouse_1.id).include?(company_2)).to eq(false)
      end
    end
  end
end
