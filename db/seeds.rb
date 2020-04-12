2.times do
  Organization.create!(
    name: Faker::Company.industry,
    address1: Faker::Address.building_number + " " + Faker::Address.street_name,
    address2: Faker::Address.secondary_address + " " + Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    country: Faker::Address.country,
    pin_code: Faker::Number.number(digits: 6).to_s,
    description: Faker::Company.catch_phrase
  )
end

User.create!(
  first_name: "Palash",
  last_name: "Bera",
  mobile_number: "1234567890",
  email: "palashbera1234@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  admin: true,
  confirmation_sent_at: Time.current,
  confirmed_at: Time.current + 5.minutes,
  organization_id: 1
)

User.create!(
  first_name: "Arnab",
  last_name: "Roy",
  mobile_number: "9931148514",
  email: "rarnab021@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  admin: true,
  confirmation_sent_at: Time.current,
  confirmed_at: Time.current + 5.minutes,
  organization_id: 2
)

[1, 2].each do |org_id|
  5.times do
    Company.create!(
      name: Faker::Company.industry + " #" + rand(99_999).to_s,
      address1: Faker::Address.building_number + " " + Faker::Address.street_name,
      address2: Faker::Address.secondary_address + " " + Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state,
      country: Faker::Address.country,
      pin_code: Faker::Number.number(digits: 6).to_s,
      phone_number: Faker::PhoneNumber.phone_number_with_country_code,
      organization_id: org_id
    )
  end

  250.times do
    Brand.create!(
      name: Faker::Appliance.brand + " #" + rand(999).to_s + "-" + Faker::Esport.game + " ## " + rand(999).to_s,
      archive: Faker::Boolean.boolean,
      organization_id: org_id
    )
  end

  Uom.create(name: "dozen",      short_name: "doz", archive: Faker::Boolean.boolean, organization_id: org_id)
  Uom.create(name: "inch",       short_name: "in",  archive: Faker::Boolean.boolean, organization_id: org_id)
  Uom.create(name: "gallon",     short_name: "gal", archive: Faker::Boolean.boolean, organization_id: org_id)
  Uom.create(name: "yard",       short_name: "yd",  archive: Faker::Boolean.boolean, organization_id: org_id)
  Uom.create(name: "milliliter", short_name: "ml",  archive: Faker::Boolean.boolean, organization_id: org_id)

  5.times do
    Warehouse.create!(
      name: Faker::Commerce.department + "##" + rand(99).to_s,
      address1: Faker::Address.building_number + " " + Faker::Address.street_name,
      address2: Faker::Address.secondary_address + " " + Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state,
      country: Faker::Address.country,
      pin_code: Faker::Number.number(digits: 6).to_s,
      phone_number: Faker::PhoneNumber.phone_number_with_country_code,
      company_id: Company.where(organization_id: org_id).pluck(:id).sample,
      organization_id: org_id
    )
  end

  250.times do
    ItemGroup.create!(
      name: Faker::Beer.name + " #" + rand(99).to_s + "-" + Faker::Lorem.word,
      description: Faker::Lorem.sentence(word_count: 6, supplemental: true, random_words_to_add: 3),
      archive: Faker::Boolean.boolean,
      organization_id: org_id
    )
  end

  if org_id == 1
    Company.update_all(created_by_id: 1)
    Brand.update_all(created_by_id: 1)
    Uom.update_all(created_by_id: 1)
    Warehouse.update_all(created_by_id: 1)
    ItemGroup.update_all(created_by_id: 1)
  else
    Company.where(created_by_id: nil).update_all(created_by_id: 2)
    Brand.where(created_by_id: nil).update_all(created_by_id: 2)
    Uom.where(created_by_id: nil).update_all(created_by_id: 2)
    Warehouse.where(created_by_id: nil).update_all(created_by_id: 2)
    ItemGroup.where(created_by_id: nil).update_all(created_by_id: 2)
  end
end
