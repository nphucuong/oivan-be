FactoryBot.define do
  factory :test do
    name { Faker::Name.name }
  end
end
