require "rails_helper"

RSpec.describe Vendorship, type: :model do
  let(:user)       { create(:user) }
  let(:vendorship) { create(:vendorship) }

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
    it { should have_db_column(:vendor_id) }
    it { should have_db_column(:invitation_sent_at) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:vendor_id) }
    it { should have_db_index([:organization_id, :vendor_id]) }
  end

  describe "#associations" do
    it { should belong_to(:vendor) }
  end

  describe "#validations" do
    context "when same vendor for an organization" do
      let!(:vendorship) { create(:vendorship) }

      it "should not save this uom" do
        new_vendorship = build(:vendorship, vendor_id: vendorship.vendor_id)
        new_vendorship.valid?
        expect(new_vendorship.errors[:vendor_id]).to include("has already been taken")
      end
    end
  end

  describe "#status" do
    let!(:vendorship) { create(:vendorship) }

    context "when vendor invitation is pending" do
      it "should return pending" do
        expect(vendorship.status).to eq(I18n.t("status.pending"))
      end
    end

    context "when vendor invitation is not pending and vendor is archived" do
      it "should return archived" do
        vendorship.update(archive: true)
        vendorship.vendor.update(invitation_accepted_at: DateTime.now)
        expect(vendorship.status).to eq(I18n.t("status.archived"))
      end
    end

    context "when vendor invitation is not pending and vendor is not archived" do
      it "should return active" do
        vendorship.update(archive: false)
        vendorship.vendor.update(invitation_accepted_at: DateTime.now)
        expect(vendorship.status).to eq(I18n.t("status.active"))
      end
    end
  end

  describe "#toggle_archive" do
    context "when archive is true" do
      let(:user) { create(:user, archive: true) }

      it "should set archive as false" do
        user.toggle_archive
        expect(user.archive).to eq(false)
      end
    end

    context "when archive is false" do
      let(:user) { create(:user, archive: false) }

      it "should set archive as true" do
        user.toggle_archive
        expect(user.archive).to eq(true)
      end
    end
  end
end
