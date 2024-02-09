def difficulty(difficulty)
  case difficulty
  when "très facile"
    :very_easy
  when "facile"
    :easy
  when "Niveau moyen"
    :medium
  when "difficile"
    :hard
  end
end

def budget(budget)
  case budget
  when "bon marché"
    :cheap
  when "Coût moyen"
    :normal
  when "assez cher"
    :expensive
  end
end

def duration(duration)
  duration.gsub!("j", "d")

  if duration.ends_with?("h") || duration.ends_with?("n")
    ChronicDuration.parse(duration)
  else
    ChronicDuration.parse("#{duration}m")
  end
end

def rate(rate)
  rate.to_f unless rate.blank?
end

file_path = Rails.root.join('db', 'recipes.json')

recipes = JSON.parse(File.read(file_path))["recipes"]

recipes.each do |recipe|
  r = Recipe.new(
    name: recipe["name"].capitalize,
    image: recipe["image"],
    author: recipe["author"],
    author_tip: recipe["author_tip"],
    rate: rate(recipe["rate"]),
    nb_comments: recipe["nb_comments"].to_i,
    people_quantity: recipe["people_quantity"].to_i,

    prep_time: duration(recipe["prep_time"]),
    cook_time: duration(recipe["cook_time"]),
    total_time: duration(recipe["total_time"]),

    difficulty: difficulty(recipe["difficulty"]),
    budget: budget(recipe["budget"])
  )

  recipe["tags"].each do |tag|
    tag = Tag.find_or_create_by!(name: tag)
    r.tags << tag
  end

  recipe["ingredients"].each do |ingredient|
    ingredient = Ingredient.create(name: ingredient, recipe: r)
  end

  puts recipe["name"]

  # TODO: add ingredients

  r.save!
end


