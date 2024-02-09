FactoryBot.define do
  factory :recipe do
    name { Faker::Food.dish }
    budget { Recipe.budgets.keys.sample }
    difficulty { Recipe.difficulties.keys.sample }
    total_time { rand(10..120) }
    rate { rand(1.0..5.0).round(2) }
    nb_comments { rand(0..100) }
    image { Faker::Internet.url }
  end
end
