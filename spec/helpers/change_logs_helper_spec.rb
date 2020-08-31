require "rails_helper"

RSpec.describe ChangeLogsHelper, type: :helper do
  let(:user)             { create(:user) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
    extend SessionsHelper
  end

  describe "#display_item_name" do
    let(:item) { create :item, name: "Bearing" }

    it "should find and return name of the item which is supplied as parameter" do
      expect(display_item_name(item.id)).to eq("Bearing")
    end
  end

  describe "#display_uom_name" do
    let(:uom) { create :uom, name: "Kilogram" }

    it "should find and return name of the uom which is supplied as parameter" do
      expect(display_uom_name(uom.id)).to eq("Kilogram")
    end
  end

  describe "#display_cost_center_name" do
    let(:cost_center) { create :cost_center, name: "Kiln" }

    it "should find and return name of the cost center which is supplied as parameter" do
      expect(display_cost_center_name(cost_center.id)).to eq("Kiln")
    end
  end

  describe "#display_make" do
    let(:brand) { create(:brand, name: "Lenovo") }
    let(:make)  { create(:make, brand: brand, cat_no: "1234") }

    it "should find and should return brand with category number" do
      expect(display_make(make.id)).to eq("Lenovo - 1234")
    end
  end
end
