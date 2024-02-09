FactoryBot.define do
  factory :tag do
    name { Faker::Food.unique.ethnic_category }
  end
end
