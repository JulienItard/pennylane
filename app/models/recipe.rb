class Recipe < ApplicationRecord
  SORT_BY = %w[rate nb_comments total_time].freeze

  has_many :recipe_tags
  has_many :tags, through: :recipe_tags

  has_many :ingredients, dependent: :destroy

  enum difficulty: { very_easy: 0, easy: 1, medium: 2, hard: 3 }  # trés facile, facile, Niveau moyen, difficile
  enum budget: { cheap: 0, normal: 1, expensive: 2 } # bon marché, Coût moyen, assez cher

  # These 2 enums could be extracted to 2 separate models with has_one association
  # but it will slow down search queries because of joins
  # we could consider it if these lists change often, need CRUD, or more details.

  validates :name, presence: true
  validates :budget, presence: true, inclusion: { in: budgets.keys }
  validates :difficulty, presence: true, inclusion: { in: difficulties.keys }

  scope :with_tags, -> (tag_ids) {
    joins(:tags)
      .where(tags: { id: tag_ids })
      .group('recipes.id')
      .having('COUNT(distinct tags.id) = ?', tag_ids.count)
  }

  scope :with_ingredients, ->(ingredient_names) {
    ingredient_names = ingredient_names.map { |name| "%#{name.downcase}%" }

    recipes = Recipe.joins(:ingredients)
      .where('lower(ingredients.name) ILIKE ANY (array[?])', ingredient_names)
      .group('recipes.id')
      .having('COUNT(DISTINCT ingredients.name) >= ?', ingredient_names.size)

    where(id: recipes.select('recipes.id'))
  }
end
