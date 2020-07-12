FactoryBot.define do
  factory :item_image do
    image { fixture_file_upload(Rails.root.join("spec", "fixtures", "images", "missing_image.jpg"), "image/jpg") }
    item
  end
end
