require "rails_helper"

RSpec.describe ItemImage, type: :model do
  let(:user) { create(:user) }
  let(:item) { create(:item) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "user_tracking_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:item_id) }
    it { should have_db_column(:image_file_name) }
    it { should have_db_column(:image_content_type) }
    it { should have_db_column(:image_file_size) }
    it { should have_db_column(:image_updated_at) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:item_id) }
  end

  describe "#associations" do
    it { should belong_to(:item) }
  end

  describe "#validations" do
    it { should validate_presence_of(:image) }
    it { should validate_attachment_size(:image).less_than(2.megabytes) }
    it { should validate_attachment_content_type(:image).allowing("image/png", "image/jpeg") }
  end

  describe "#scopes" do
    let!(:item_image) { create :item_image, item_id: item.id }

    it "should return images associated with an item" do
      expect(ItemImage.item_filter(item.id).include?(item_image)).to eq(true)
    end
  end
end
