require "rails_helper"

RSpec.describe IndentItem, type: :model do
  let(:user)        { create(:user) }
  let(:indent_item) { create(:indent_item) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
  end

  it_behaves_like "user_tracking_module"
  it_behaves_like "organization_association_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:indent_id) }
    it { should have_db_column(:item_id) }
    it { should have_db_column(:make_id) }
    it { should have_db_column(:uom_id) }
    it { should have_db_column(:cost_center_id) }
    it { should have_db_column(:quantity) }
    it { should have_db_column(:note) }
    it { should have_db_column(:priority) }
    it { should have_db_column(:approval_request_id) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:indent_id) }
    it { should have_db_index(:item_id) }
    it { should have_db_index(:make_id) }
    it { should have_db_index(:uom_id) }
    it { should have_db_index(:cost_center_id) }
  end

  describe "#enums" do
    it { should define_enum_for(:priority).with_values(default: "default", high: "high", medium: "medium", low: "low").backed_by_column_of_type(:string).with_suffix }
    it { should define_enum_for(:status).with_values(pending: "pending", approved: "approved", amended: "amended", rejected: "rejected", cancelled: "cancelled", approval_pending: "approval_pending").backed_by_column_of_type(:string) }
  end

  describe "#callbacks" do
    context "when note contains extra space" do
      it "should remove extra space" do
        new_indent_item = build(:indent_item, note: " sachin ")
        new_indent_item.valid?
        expect(new_indent_item.note).to eq ("sachin")
      end
    end
  end

  describe "#associations" do
    it { should belong_to(:indent) }
    it { should belong_to(:item) }
    it { should belong_to(:make).optional }
    it { should belong_to(:uom) }
    it { should belong_to(:cost_center) }
    it { should belong_to(:approval_request).optional }

    it { should have_many(:approval_requests).dependent(:destroy) }
    it { should have_many(:approval_request_users).through(:approval_request) }
  end

  describe "#validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:priority) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end

  describe "#scopes" do
    context "brand_with_cat_no_search" do
      let(:brand)       { create :brand, name: "Lakme" }
      let(:make)        { create :make, brand_id: brand.id }
      let(:indent_item) { create :indent_item, make_id: make.id }

      it "should return item with specific brand name or category number" do
        expect(IndentItem.brand_and_cat_no_filter("LAkme").include?(indent_item)).to eq(true)
      end
    end
  end

  describe "#quantity_with_uom" do
    let!(:indent_item) { create(:indent_item) }

    it "should return quantity with uom of indent item" do
      quantity_with_uom = "#{indent_item.quantity} #{indent_item.uom.short_name}"
      expect(indent_item.quantity_with_uom).to eq(quantity_with_uom)
    end
  end

  describe "#display_priority" do
    let!(:indent_item) { create(:indent_item, priority: "high") }

    it "should return High" do
      expect(indent_item.display_priority).to eq("High")
    end
  end

  describe "#brand_details" do
    context "when make not present" do
      let!(:indent_item) { create(:indent_item, make_id: nil) }

      it "should return N/A" do
        expect(indent_item.brand_details).to eq("N/A")
      end
    end

    context "when make not present" do
      let!(:brand)       { create(:brand, name: "KFC") }
      let!(:make)        { create(:make, brand_id: brand.id, cat_no: "1234") }
      let!(:indent_item) { create(:indent_item, make_id: make.id) }

      it "should return brand details" do
        expect(indent_item.brand_details).to eq("KFC – 1234")
      end
    end
  end

  # TODO: add specs for send_approval_request_mails
  # TODO: add specs for create_approval_requests

  describe "#unlocked?" do
    context "when indent item is locked" do
      let!(:indent_item) { create(:indent_item, locked: true) }

      it "should return false" do
        expect(indent_item.unlocked?).to eq(false)
      end
    end

    context "when indent item is unlocked" do
      let!(:indent_item) { create(:indent_item, locked: false) }

      it "should return true" do
        expect(indent_item.unlocked?).to eq(true)
      end
    end
  end

  describe "#mark_as_rejected" do
    let!(:indent_item) { create(:indent_item, status: "pending") }

    it "should update status of indent item" do
      indent_item.mark_as_rejected
      expect(indent_item.rejected?).to eq(true)
      expect(indent_item.locked).to eq(false)
      expect(indent_item.approval_request_id).to eq(nil)
    end
  end

  describe "#mark_as_approved" do
    let!(:indent_item) { create(:indent_item, status: "pending") }

    it "should update status of indent item" do
      indent_item.mark_as_approved
      expect(indent_item.approved?).to eq(true)
      expect(indent_item.locked).to eq(true)
      expect(indent_item.approval_request_id).to eq(nil)
    end
  end

  describe "#mark_as_amended" do
    let!(:indent_item) { create(:indent_item, status: "pending") }

    it "should update status of indent item" do
      indent_item.mark_as_amended
      expect(indent_item.amended?).to eq(true)
      expect(indent_item.locked).to eq(true)
    end
  end

  describe "#mark_as_cancelled" do
    let!(:indent_item) { create(:indent_item, status: "pending") }

    it "should update status of indent item" do
      indent_item.mark_as_cancelled
      expect(indent_item.cancelled?).to eq(true)
      expect(indent_item.locked).to eq(true)
    end
  end

  describe "#mark_as_pending" do
    let!(:indent_item) { create(:indent_item, status: "cancelled") }

    it "should update status of indent item" do
      indent_item.mark_as_pending
      expect(indent_item.pending?).to eq(true)
      expect(indent_item.locked).to eq(false)
    end
  end

  describe "#mark_as_approval_pending" do
    let!(:indent_item) { create(:indent_item, status: "cancelled") }

    it "should update status of indent item" do
      indent_item.mark_as_approval_pending
      expect(indent_item.approval_pending?).to eq(true)
      expect(indent_item.locked).to eq(true)
    end
  end

  describe "#send_approval_requests" do
    let!(:indent_item)           { create(:indent_item, status: "approval_pending") }
    let!(:approval_request_1)    { create(:approval_request, approval_requestable_id: indent_item.id) }
    let!(:approval_request_2)    { create(:approval_request, approval_requestable_id: indent_item.id, next_approval_request_id: approval_request_1.id) }
    let!(:approval_request_user) { create(:approval_request_user, approval_request_id: approval_request_1.id) }

    context "when indent item hasn't approval request" do
      it "should mark indent item as approved" do
        indent_item.update(approval_request_id: approval_request_1.id)
        indent_item.send_approval_requests
        expect(indent_item.approved?).to eq(true)
      end
    end

    context "when indent item has approval request" do
      it "should send approval request mail" do
        indent_item.update(approval_request_id: approval_request_2.id)
        indent_item.send_approval_requests
        expect(indent_item.reload.approval_request_id).to eq(approval_request_1.id)
        expect(indent_item.reload.approval_pending?).to eq(true)
      end
    end
  end

  describe "#display_status" do
    let!(:indent_item) { create(:indent_item, status: "pending") }

    it "should return status with proper format" do
      expect(indent_item.display_status).to eq("Pending")
    end
  end
end
