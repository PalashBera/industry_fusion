organization = Organization.create!(
  name: "Industry Fusion Pvt. Ltd.",
  address1: Faker::Address.building_number + ", " + Faker::Address.street_name,
  address2: Faker::Address.secondary_address + ", " + Faker::Address.street_address,
  city: Faker::Address.city,
  state: Faker::Address.state,
  country: Faker::Address.country,
  pin_code: Faker::Number.number(digits: 6).to_s
)

user1 = User.create!(
  first_name: "Palash",
  last_name: "Bera",
  mobile_number: "1234567890",
  email: "palashbera1234@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  admin: true,
  confirmation_sent_at: Time.current,
  confirmed_at: Time.current + 5.minutes,
  organization_id: organization.id
)

user2 = User.create!(
  first_name: "Arnab",
  last_name: "Roy",
  mobile_number: "9931148514",
  email: "rarnab021@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  admin: true,
  confirmation_sent_at: Time.current,
  confirmed_at: Time.current + 5.minutes,
  organization_id: organization.id
)

5.times do |t|
  User.current_user = [user1, user2].sample
  company_name = Faker::Company.name + "+" + t.to_s

  company = Company.create!(
    name: company_name,
    short_name: company_name.split(" ").map(&:first).join + " #{t}",
    address1: Faker::Address.building_number + ", " + Faker::Address.street_name,
    address2: Faker::Address.secondary_address + ", " + Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    country: Faker::Address.country,
    pin_code: Faker::Number.number(digits: 6).to_s,
    phone_number: Faker::PhoneNumber.phone_number_with_country_code,
    organization_id: organization.id
  )

  [2, 3, 4].sample.times do |tt|
    warehouse_name = Faker::Commerce.department + "+" + t.to_s + tt.to_s

    Warehouse.create!(
      name: warehouse_name,
      short_name: warehouse_name.split(" ").map(&:first).join + " #{t}#{tt}",
      address1: Faker::Address.building_number + ", " + Faker::Address.street_name,
      address2: Faker::Address.secondary_address + ", " + Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state,
      country: Faker::Address.country,
      pin_code: Faker::Number.number(digits: 6).to_s,
      phone_number: Faker::PhoneNumber.phone_number_with_country_code,
      company_id: company.id,
      organization_id: organization.id
    )
  end
end

50.times do |t|
  User.current_user = [user1, user2].sample

  Brand.create!(
    name: Faker::Appliance.brand + " - " + Faker::Esport.game + "+" + t.to_s,
    archive: Faker::Boolean.boolean,
    organization_id: organization.id
  )
end

User.current_user = [user1, user2].sample

Uom.create(name: "dozen",      short_name: "doz", archive: Faker::Boolean.boolean, organization_id: organization.id)
Uom.create(name: "inch",       short_name: "in",  archive: Faker::Boolean.boolean, organization_id: organization.id)
Uom.create(name: "gallon",     short_name: "gal", archive: Faker::Boolean.boolean, organization_id: organization.id)
Uom.create(name: "yard",       short_name: "yd",  archive: Faker::Boolean.boolean, organization_id: organization.id)
Uom.create(name: "milliliter", short_name: "ml",  archive: Faker::Boolean.boolean, organization_id: organization.id)

50.times do |t|
  User.current_user = [user1, user2].sample

  ItemGroup.create!(
    name: Faker::Beer.name + "+" + t.to_s,
    description: Faker::Lorem.sentence(word_count: 6, supplemental: true, random_words_to_add: 3),
    archive: Faker::Boolean.boolean,
    organization_id: organization.id
  )

  CostCenter.create!(
    name: Faker::Team.name + "+" + t.to_s,
    description: Faker::Lorem.sentence(word_count: 6, supplemental: true, random_words_to_add: 3),
    archive: Faker::Boolean.boolean,
    organization_id: organization.id
  )
end

50.times do |t|
  User.current_user = [user1, user2].sample

  Item.create!(
    name: Faker::Appliance.equipment + "+" + t.to_s,
    archive: Faker::Boolean.boolean,
    uom_id: organization.uoms.sample.id,
    item_group_id: organization.item_groups.sample.id,
    organization_id: organization.id
  )
end

250.times do |t|
  User.current_user = [user1, user2].sample

  Make.create!(
    brand_id: organization.brands.sample.id,
    item_id: organization.items.sample.id,
    cat_no: Faker::Code.isbn + t.to_s,
    organization_id: organization.id
  )
end

10.times do
  User.current_user = [user1, user2].sample

  Vendor.create!(
    name: Faker::Name.unique.name,
    email: Faker::Internet.unique.email,
    organization_id: organization.id
  )
end

Organization.update_all(created_by_id: [user1, user2].sample.id)
