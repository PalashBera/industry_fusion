require "rails_helper"

RSpec.describe IndentItem, type: :model do
  let(:user)        { create(:user) }
  let(:indent_item) { create(:indent_item) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
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

    it { should have_many(:approvals).dependent(:destroy) }
  end

  describe "#validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:priority) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
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

  describe "#send_for_approval" do
    context "when approval is not present" do
      it "should marked as approved" do
        indent_item.send_for_approval
        expect(indent_item.approved?).to eq(true)
      end
    end

    context "when approval is present" do
      let!(:approval_level) { create(:approval_level, approval_type: "indent") }

      it "should send approval request mail" do
        indent_item.create_approvals
        expect {
          indent_item.send_for_approval
        }.to enqueue_job(ActionMailer::MailDeliveryJob)
      end

      it "should locked the indent item" do
        indent_item.create_approvals
        indent_item.send_for_approval
        expect(indent_item.locked).to eq(true)
      end

      it "should update current_level to 1" do
        indent_item.create_approvals
        indent_item.send_for_approval
        expect(indent_item.current_level).to eq(1)
      end
    end
  end

  describe "#create_approvals" do
    let!(:approval_level) { create(:approval_level, approval_type: "indent") }

    it "should update approval_ids" do
      indent_item.create_approvals
      expect(indent_item.approval_ids.present?).to eq(true)
    end
  end

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
      expect(indent_item.status).to eq("rejected")
      expect(indent_item.locked).to eq(false)
    end
  end

  describe "#mark_as_approved" do
    let!(:indent_item) { create(:indent_item, status: "pending") }

    it "should update status of indent item" do
      indent_item.mark_as_approved
      expect(indent_item.status).to eq("approved")
      expect(indent_item.locked).to eq(true)
    end
  end

  describe "#mark_as_amended" do
    let!(:indent_item) { create(:indent_item, status: "pending") }

    it "should update status of indent item" do
      indent_item.mark_as_amended
      expect(indent_item.status).to eq("amended")
      expect(indent_item.locked).to eq(true)
    end
  end

  describe "#display_status" do
    let!(:indent_item) { create(:indent_item, status: "pending") }

    it "should return status with proper format" do
      expect(indent_item.display_status).to eq("Pending")
    end
  end
end
