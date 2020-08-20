require "rails_helper"

RSpec.describe SessionsHelper, type: :helper do
  let(:admin_user) { create(:admin_user) }
  let(:user)       { create(:user) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
  end

  describe "#admin_user_signed_in?" do
    context "when admin is logged in" do
      let(:current_user) { admin_user }

      it "should return true" do
        expect(admin_user_signed_in?).to eq(true)
      end
    end

    context "when general user is logged in" do
      let(:current_user) { user }

      it "should return false" do
        expect(admin_user_signed_in?).to eq(false)
      end
    end
  end

  describe "#current_organization" do
    context "when user is logged in" do
      let(:current_user) { user }

      it "should return logged in user's organization" do
        expect(current_organization).to eq(user.organization)
      end
    end

    context "when user is not logged in" do
      let(:current_user) { nil }

      it "should return nil" do
        expect(current_organization).to eq(nil)
      end
    end
  end

  describe "#allow_organization_settings?" do
    context "when current organization is present and user is admin" do
      let(:current_user) { admin_user }

      it "should return true" do
        expect(allow_organization_settings?).to eq(true)
      end
    end

    # context "when current organization is not present but user is admin" do
    #   let(:current_user) { admin_user }

    #   it "should return false" do
    #     expect(allow_organization_settings?).not_to eq(true)
    #   end
    # end

    context "when current organization is present but user is not admin" do
      let(:current_user) { user }

      it "should return false" do
        expect(allow_organization_settings?).not_to eq(true)
      end
    end

    # context "when current organization is not present but user is not admin" do
    #   let(:current_user) { user }

    #   it "should return false" do
    #     user.update(organization_id: nil)
    #     expect(allow_organization_settings?).not_to eq(true)
    #   end
    # end
  end

  describe "#accessible_warehouse_ids" do
    let!(:warehouse_1)    { create :warehouse }
    let!(:warehouse_2)    { create :warehouse }
    let!(:warehouse_3)    { create :warehouse }
    let!(:warehouse_4)    { create :warehouse }
    let!(:organization_1) { create :organization }

    context "when admin user is signed in" do
      let(:admin_user)   { create :admin_user, organization_id: user.organization.id }
      let(:current_user) { admin_user }

      it "should return ids of all the warehouses of that organization" do
        warehouse_4.update_column(:organization_id, organization_1.id)
        expect(accessible_warehouse_ids).to eq(Warehouse.where(organization_id: user.organization.id).pluck(:id))
        expect(accessible_warehouse_ids).to_not eq(Warehouse.unscoped.all.pluck(:id))
      end
    end

    context "when user having any other role is logged in" do
      let(:current_user) { user }

      it "should return warehouse ids assigned to that user" do
        user.update_column(:warehouse_ids, [warehouse_3.id, warehouse_4.id])
        expect(accessible_warehouse_ids).to eq([warehouse_3.id, warehouse_4.id])
      end
    end
  end
end
