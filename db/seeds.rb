# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
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

5.times do
  company1 = Company.create!(
    name: Faker::Company.industry + " #" + rand(99_999).to_s,
    address1: Faker::Address.building_number + " " + Faker::Address.street_name,
    address2: Faker::Address.secondary_address + " " + Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    country: Faker::Address.country,
    pin_code: Faker::Number.number(digits: 6).to_s,
    phone_number: Faker::PhoneNumber.phone_number_with_country_code,
    organization_id: 1
  )

  company1.update_attributes(created_by_id: 1)

  company2 = Company.create!(
    name: Faker::Company.industry + " #" + rand(99_999).to_s,
    address1: Faker::Address.building_number + " " + Faker::Address.street_name,
    address2: Faker::Address.secondary_address + " " + Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    country: Faker::Address.country,
    pin_code: Faker::Number.number(digits: 6).to_s,
    phone_number: Faker::PhoneNumber.phone_number_with_country_code,
    organization_id: 2
  )

  company2.update_attributes(created_by_id: 2)
end

250.times do
  brand1 = Brand.create!(
    name: Faker::Appliance.brand + " #" + rand(999).to_s + "-" + Faker::Esport.game + " ## " + rand(999).to_s,
    archive: Faker::Boolean.boolean,
    organization_id: 1
  )

  brand1.update_attributes(created_by_id: 1)

  brand2 = Brand.create!(
    name: Faker::Appliance.brand + " #" + rand(9999).to_s + "-" + Faker::Esport.game + " ## " + rand(999).to_s,
    archive: Faker::Boolean.boolean,
    organization_id: 2
  )

  brand2.update_attributes(created_by_id: 2)
end

[1, 2].each do |org_id|
  Uom.create(name: "dozen",      short_name: "doz", archive: Faker::Boolean.boolean, organization_id: org_id)
  Uom.create(name: "inch",       short_name: "in",  archive: Faker::Boolean.boolean, organization_id: org_id)
  Uom.create(name: "gallon",     short_name: "gal", archive: Faker::Boolean.boolean, organization_id: org_id)
  Uom.create(name: "yard",       short_name: "yd",  archive: Faker::Boolean.boolean, organization_id: org_id)
  Uom.create(name: "milliliter", short_name: "ml",  archive: Faker::Boolean.boolean, organization_id: org_id)

  if org_id == 1
    Uom.update_all(created_by_id: 1)
  else
    Uom.where(created_by_id: nil).update_all(created_by_id: 2)
  end
end
