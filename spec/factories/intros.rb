FactoryBot.define do
  factory :intro do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    website { Faker::Lorem.sentence }
    profile { Faker::Lorem.sentence }
    association :user
  end
end
