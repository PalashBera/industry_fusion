organization = Organization.create!(
  name: "Industry Fusion Pvt. Ltd.",
  fy_start_month: 4
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
    short_name: company_name.split.first[0..2],
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
      short_name: "W#{t}#{tt}",
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
    hsn_code: Faker::Number.number(digits: 8),
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

  item = Item.create!(
    name: Faker::Appliance.equipment + "+" + t.to_s,
    archive: Faker::Boolean.boolean,
    uom_id: organization.uoms.sample.id,
    item_group_id: organization.item_groups.sample.id,
    organization_id: organization.id
  )

  3.times do |tt|
    Make.create!(
      brand_id: organization.brands.sample.id,
      item_id: item.id,
      cat_no: Faker::Code.isbn + tt.to_s,
      archive: Faker::Boolean.boolean,
      organization_id: organization.id
    )
  end

  Indentor.create!(
    name: Faker::Name.name + Time.zone.now.to_s,
    archive: Faker::Boolean.boolean,
    organization_id: organization.id
  )

  PaymentTerm.create!(
    name: Faker::Name.name + Time.zone.now.to_s,
    description: Faker::Lorem.sentence(word_count: 6, supplemental: true, random_words_to_add: 3),
    archive: Faker::Boolean.boolean,
    organization_id: organization.id
  )

  ReorderLevel.create!(
    item_id: item.id,
    warehouse_id: User.current_user.organization.warehouses.non_archived.sample.id,
    quantity: rand(1..100),
    priority: ReorderLevel::PRIORITY_LIST.sample,
    archive: Faker::Boolean.boolean,
    organization_id: organization.id
  )

  WarehouseLocation.create!(
    name: "Location - #{t}",
    warehouse_id: User.current_user.organization.warehouses.non_archived.sample.id,
    archive: Faker::Boolean.boolean,
    organization_id: organization.id
  )
end

def generate_indent_items_attributes
  attribute_hash = []

  [2, 3, 4].sample.times do
    organization = Organization.first
    item = organization.items.sample
    make = item.makes.sample && uom = item.uom

    attribute_hash.push({ requirement_date: Date.today + rand(1..10).days, item_id: item.id, make_id: make.id, uom_id: uom.id, cost_center_id: organization.cost_centers.sample.id,
                          quantity: Faker::Number.decimal(l_digits: 5, r_digits: 2), priority: IndentItem::PRIORITY_LIST.sample, organization_id: organization.id })
  end

  attribute_hash
end

20.times do |t|
  User.current_user = [user1, user2].sample
  company = organization.companies.sample
  warehouse = company.warehouses.sample
  indentors = (1..20).to_a

  Indent.create!(
    organization_id: organization.id,
    indentor_id: indentors[t],
    company_id: company.id,
    warehouse_id: warehouse.id,
    indent_items_attributes: generate_indent_items_attributes
  )
end

50.times do |t|
  vendor = Vendor.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    mobile_number: Faker::Number.number(digits: 10).to_s,
    email: Faker::Internet.email,
    password: "123456",
    password_confirmation: "123456",
    confirmation_sent_at: Time.current,
    confirmed_at: Time.current + 5.minutes,
    invitation_accepted_at: Time.now
  )

  StoreInformation.new(
    vendor_id: vendor.id,
    name: "Store ##{t}",
    address1: Faker::Address.mail_box,
    city: Faker::Address.city,
    state: Faker::Address.state,
    country: Faker::Address.country,
    pin_code: Faker::Number.number(digits: 6).to_s,
    phone_number: Faker::PhoneNumber.phone_number_with_country_code,
    pan_number: "TAVPR0507C",
    gstn: "29AAFCC9980M1ZR"
  ).save(validate: false)
end

organization.vendors << Vendor.last(50)

Organization.update_all(created_by_id: [user1, user2].sample.id)

PageHelp.create!(
  controller_name: "master/brands",
  action_name: "index",
  help_text: "This is product brands list page. Create brand which will be associated with item in the make section.",
  help_type: "primary"
)
