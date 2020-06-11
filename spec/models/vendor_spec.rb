require "rails_helper"

RSpec.describe Vendor, type: :model do
  it_behaves_like "modal_formable"
  it_behaves_like "user_informable"

  describe "#validations" do
    it { should have_one(:store_information) }
  end
end
