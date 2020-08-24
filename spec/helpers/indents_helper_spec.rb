require "rails_helper"

RSpec.describe IndentsHelper, type: :helper do
  let(:user) { create(:user) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
    extend SessionsHelper
  end

  describe "#company_dropdown_list" do
    let(:company_1)    { create :company, archive: false }
    let(:company_2)    { create :company, archive: true }
    let(:warehouse_1)  { create :warehouse, company_id: company_1.id }
    let(:warehouse_2)  { create :warehouse, company_id: company_2.id }
    let(:current_user) { user }

    context "when indent is a new instance" do
      let(:indent) { build(:indent) }

      it "should return companies which belong to current user's warehouses" do
        current_user.update(warehouse_ids: [warehouse_1.id, warehouse_2.id])
        expect(company_dropdown_list(indent).include?([company_1.name, company_1.id])).to eq(true)
        expect(company_dropdown_list(indent).include?([company_2.name, company_2.id])).to eq(false)
      end
    end

    context "when indent belongs to a non archived company" do
      let(:indent) { create(:indent, company_id: company_1.id, warehouse_id: warehouse_1.id) }

      it "should return all non archived companies" do
        current_user.update(warehouse_ids: [warehouse_1.id, warehouse_2.id])
        expect(company_dropdown_list(indent).include?([company_1.name, company_1.id])).to eq(true)
        expect(company_dropdown_list(indent).include?([company_2.name, company_2.id])).to eq(false)
      end
    end

    context "when indent belongs to a archived company" do
      let(:indent) { create(:indent, company_id: company_2.id, warehouse_id: warehouse_2.id) }

      it "should return all non archived companies along with associate company" do
        current_user.update(warehouse_ids: [warehouse_1.id, warehouse_2.id])
        expect(company_dropdown_list(indent).include?([company_1.name, company_1.id])).to eq(true)
        expect(company_dropdown_list(indent).include?([company_2.name, company_2.id])).to eq(true)
      end
    end
  end

  describe "#warehouse_dropdown_list" do
    let(:company)      { create :company, archive: false }
    let(:warehouse_1)  { create :warehouse, company_id: company.id, archive: false }
    let(:warehouse_2)  { create :warehouse, company_id: company.id, archive: true }
    let(:current_user) { user }

    context "when indent is a new instance" do
      let(:indent) { build(:indent) }

      it "should return empty list" do
        current_user.update(warehouse_ids: [warehouse_1.id, warehouse_2.id])
        expect(warehouse_dropdown_list(indent).blank?).to eq(true)
        expect(warehouse_dropdown_list(indent).include?([warehouse_1.name, warehouse_1.id])).to eq(false)
        expect(warehouse_dropdown_list(indent).include?([warehouse_2.name, warehouse_2.id])).to eq(false)
      end
    end

    context "when indent belongs to a non archived warehouse" do
      let(:indent) { create(:indent, company_id: company.id, warehouse_id: warehouse_1.id) }

      it "should return all non archived warehouses" do
        current_user.update(warehouse_ids: [warehouse_1.id, warehouse_2.id])
        expect(warehouse_dropdown_list(indent).include?([warehouse_1.name, warehouse_1.id])).to eq(true)
        expect(warehouse_dropdown_list(indent).include?([warehouse_2.name, warehouse_2.id])).to eq(false)
      end
    end

    context "when indent belongs to a archived warehouse" do
      let(:indent) { create(:indent, company_id: company.id, warehouse_id: warehouse_2.id) }

      it "should return all non archived warehouses along with associate warehouse" do
        current_user.update(warehouse_ids: [warehouse_1.id, warehouse_2.id])
        expect(warehouse_dropdown_list(indent).include?([warehouse_1.name, warehouse_1.id])).to eq(true)
        expect(warehouse_dropdown_list(indent).include?([warehouse_2.name, warehouse_2.id])).to eq(true)
      end
    end
  end

  describe "#indentor_dropdown_list" do
    let!(:indentor_1) { create :indentor, archive: false }
    let!(:indentor_2) { create :indentor, archive: true }

    context "when indentor is not present for indent" do
      let(:indent) { build(:indent) }

      it "should return non archived indentors" do
        expect(indentor_dropdown_list(indent).include?([indentor_1.name, indentor_1.id])).to eq(true)
        expect(indentor_dropdown_list(indent).include?([indentor_2.name, indentor_2.id])).to eq(false)
      end
    end

    context "when non archived indentor is present for indent" do
      let(:indent) { create(:indent, indentor_id: indentor_1.id) }

      it "should return non archived indentors" do
        expect(indentor_dropdown_list(indent).include?([indentor_1.name, indentor_1.id])).to eq(true)
        expect(indentor_dropdown_list(indent).include?([indentor_2.name, indentor_2.id])).to eq(false)
      end
    end

    context "when archived indentor is present for indent" do
      let(:indent) { create(:indent, indentor_id: indentor_2.id) }

      it "should return non archived indentors along with associate indentor" do
        expect(indentor_dropdown_list(indent).include?([indentor_1.name, indentor_1.id])).to eq(true)
        expect(indentor_dropdown_list(indent).include?([indentor_2.name, indentor_2.id])).to eq(true)
      end
    end
  end

  describe "#item_dropdown_list" do
    let!(:item_1) { create :item, archive: false }
    let!(:item_2) { create :item, archive: true }

    context "when item is not present for indent item" do
      let(:indent_item) { build(:indent_item) }

      it "should return non archived items" do
        expect(item_dropdown_list(indent_item).include?([item_1.name, item_1.id])).to eq(true)
        expect(item_dropdown_list(indent_item).include?([item_2.name, item_2.id])).to eq(false)
      end
    end

    context "when non archived item is present for indent item" do
      let(:indent_item) { create(:indent_item, item_id: item_1.id) }

      it "should return non archived items" do
        expect(item_dropdown_list(indent_item).include?([item_1.name, item_1.id])).to eq(true)
        expect(item_dropdown_list(indent_item).include?([item_2.name, item_2.id])).to eq(false)
      end
    end

    context "when archived item is present for indent item" do
      let(:indent_item) { create(:indent_item, item_id: item_2.id) }

      it "should return non archived items along with associate item" do
        expect(item_dropdown_list(indent_item).include?([item_1.name, item_1.id])).to eq(true)
        expect(item_dropdown_list(indent_item).include?([item_2.name, item_2.id])).to eq(true)
      end
    end
  end

  describe "#make_dropdown_list" do
    let!(:item)   { create(:item) }
    let!(:make_1) { create :make, item_id: item.id, archive: false }
    let!(:make_2) { create :make, item_id: item.id, archive: true }

    context "when item is not present for indent item" do
      let(:indent_item) { build(:indent_item) }

      it "should return empty list" do
        expect(make_dropdown_list(indent_item).blank?).to eq(true)
        expect(make_dropdown_list(indent_item).include?([make_1.brand_with_cat_no, make_1.id])).to eq(false)
        expect(make_dropdown_list(indent_item).include?([make_2.brand_with_cat_no, make_2.id])).to eq(false)
      end
    end

    context "when non archived make is present for indent item" do
      let(:indent_item) { create(:indent_item, item_id: item.id, make_id: make_1.id) }

      it "should return non archived makes" do
        expect(make_dropdown_list(indent_item).include?([make_1.brand_with_cat_no, make_1.id])).to eq(true)
        expect(make_dropdown_list(indent_item).include?([make_2.brand_with_cat_no, make_2.id])).to eq(false)
      end
    end

    context "when archived make is present for indent item" do
      let(:indent_item) { create(:indent_item, item_id: item.id, make_id: make_2.id) }

      it "should return non archived makes along with associate make" do
        expect(make_dropdown_list(indent_item).include?([make_1.brand_with_cat_no, make_1.id])).to eq(true)
        expect(make_dropdown_list(indent_item).include?([make_2.brand_with_cat_no, make_2.id])).to eq(true)
      end
    end
  end

  describe "#uom_dropdown_list" do
    let!(:uom)  { create :uom }
    let!(:item) { create :item, uom_id: uom.id }

    context "when item is not present for indent item" do
      let(:indent_item) { build(:indent_item) }

      it "should return empty list" do
        expect(uom_dropdown_list(indent_item).blank?).to eq(true)
        expect(uom_dropdown_list(indent_item).include?([uom.short_name, uom.id])).to eq(false)
      end
    end

    context "when item is present for indent item" do
      let(:indent_item) { create :indent_item, item_id: item.id }

      it "should return associate uoms of this item" do
        expect(uom_dropdown_list(indent_item).include?([uom.short_name, uom.id])).to eq(true)
      end
    end
  end

  describe "#cost_center_dropdown_list" do
    let!(:cost_center_1) { create :cost_center, archive: false }
    let!(:cost_center_2) { create :cost_center, archive: true }

    context "when cost center is not present for indent item" do
      let(:indent_item) { build(:indent_item) }

      it "should return non archived cost centers" do
        expect(cost_center_dropdown_list(indent_item).include?([cost_center_1.name, cost_center_1.id])).to eq(true)
        expect(cost_center_dropdown_list(indent_item).include?([cost_center_2.name, cost_center_2.id])).to eq(false)
      end
    end

    context "when non archived cost center is present for indent item" do
      let(:indent_item) { create(:indent_item, cost_center_id: cost_center_1.id) }

      it "should return non archived cost centers" do
        expect(cost_center_dropdown_list(indent_item).include?([cost_center_1.name, cost_center_1.id])).to eq(true)
        expect(cost_center_dropdown_list(indent_item).include?([cost_center_2.name, cost_center_2.id])).to eq(false)
      end
    end

    context "when archived cost center is present for indent item" do
      let(:indent_item) { create(:indent_item, cost_center_id: cost_center_2.id) }

      it "should return non archived cost centers along with associate cost center" do
        expect(cost_center_dropdown_list(indent_item).include?([cost_center_1.name, cost_center_1.id])).to eq(true)
        expect(cost_center_dropdown_list(indent_item).include?([cost_center_2.name, cost_center_2.id])).to eq(true)
      end
    end
  end

  describe "#border_bottom_attached?" do
    let(:item_1) { create(:item) }
    let(:item_2) { create(:item) }
    let(:item_3) { create(:item) }
    let(:item_4) { create(:item) }

    context "when item id is the last element of given array of ids" do
      it "should return false" do
        item_ids = [item_1.id, item_2.id, item_3.id]
        expect(border_bottom_attached?(item_ids, item_3.id)).to eq(false)
      end
    end

    context "when item id is not the last element of given array of ids" do
      it "should return true" do
        item_ids = [item_1.id, item_2.id, item_3.id]
        expect(border_bottom_attached?(item_ids, item_1.id)).to eq(true)
        expect(border_bottom_attached?(item_ids, item_2.id)).to eq(true)
      end
    end

    context "when item id is not present in given array of ids" do
      it "should return false" do
        item_ids = [item_1.id, item_2.id, item_3.id]
        expect(border_bottom_attached?(item_ids, item_4.id)).to eq(false)
      end
    end
  end

  describe "#add_active_class" do
    context "when indent item has note" do
      let(:indent_item) { create(:indent_item, note: "Hello") }

      it "should return active class" do
        expect(add_active_class(indent_item)).to eq("text-info")
      end
    end

    context "when indent item hasn't note" do
      let(:indent_item) { create(:indent_item, note: "") }

      it "should return nil" do
        expect(add_active_class(indent_item)).to eq(nil)
      end
    end
  end

  describe "#note_input_title" do
    context "when indent item has note" do
      let(:indent_item) { create(:indent_item, note: "Hello") }

      it "should return edit tile" do
        expect(note_input_title(indent_item)).to eq("Edit note")
      end
    end

    context "when indent item hasn't note" do
      let(:indent_item) { create(:indent_item, note: "") }

      it "should return add title" do
        expect(note_input_title(indent_item)).to eq("Add note")
      end
    end
  end

  describe "#indenx_note_link" do
    context "when indent item has note" do
      let(:indent_item) { create(:indent_item, note: "Hello") }

      it "should return modal link" do
        link = Nokogiri::HTML(helper.indenx_note_link(indent_item)).children.children.children[0]
        expect(link.attributes["href"].value).to eq("/procurement/indents/#{indent_item.id}")
        expect(link.attributes["data-remote"].value).to eq("true")
        expect(link.attributes["title"].value).to eq("Show Note")
        expect(link.attributes["class"].value).to eq("text-info")
      end
    end

    context "when indent item hasn't note" do
      let(:indent_item) { create(:indent_item, note: "") }

      it "should return no link" do
        link = Nokogiri::HTML(helper.indenx_note_link(indent_item)).children.children.children[0]
        expect(link.attributes["title"].value).to eq("No note present")
        expect(link.attributes["class"].value).to eq("fas fa-sticky-note disabled-icon-link")
      end
    end
  end
end
