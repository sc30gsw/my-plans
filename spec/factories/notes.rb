FactoryBot.define do
  factory :note do
    title { Faker::Lorem.sentence }
    text { Faker::Lorem.sentence }
    plan { Faker::Lorem.sentence }

    association :user

    after(:build) do |note|
      note.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
