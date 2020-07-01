FactoryBot.define do
  factory :organization do
    name           { Faker::Company.industry + (Time.now.to_f * 100000000000000000000000000000000).to_i.to_s }
    fy_start_month { 4 }
    fy_end_month   { 3 }
    subdomain      { (Time.now.to_f * 100000000000000000000000000000000).to_i.to_s }
    archive        { false }
  end
end
