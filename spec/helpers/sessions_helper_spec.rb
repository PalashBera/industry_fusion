require "rails_helper"

RSpec.describe SessionsHelper, type: :helper do
  let(:admin_user) { create(:admin_user) }
  let(:user)       { create(:user) }

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
    let(:current_user) { user }

    context "when admin is logged in" do
      it "should return true" do
        expect(current_organization).to eq(user.organization)
      end
    end

    context "when general user is logged in" do
      it "should return false" do
        user.update(organization_id: nil)
        expect(current_organization).to eq(nil)
      end
    end
  end

  describe "#allow_organization_settings?" do
    context "when current organization is present but user is admin" do
      let(:current_user) { admin_user }

      it "should return true" do
        expect(allow_organization_settings?).to eq(true)
      end
    end

    context "when current organization is not present but user is admin" do
      let(:current_user) { admin_user }

      it "should return false" do
        admin_user.update(organization_id: nil)
        expect(allow_organization_settings?).not_to eq(true)
      end
    end

    context "when current organization is present but user is not admin" do
      let(:current_user) { user }

      it "should return false" do
        expect(allow_organization_settings?).not_to eq(true)
      end
    end

    context "when current organization is not present but user is not admin" do
      let(:current_user) { user }

      it "should return false" do
        user.update(organization_id: nil)
        expect(allow_organization_settings?).not_to eq(true)
      end
    end
  end
end
