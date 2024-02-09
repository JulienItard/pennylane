class RecipeSearchService
  RECIPES_PER_PAGE = 12

  def initialize(params)
    @recipes = Recipe.all.select(:id, :name, :image, :total_time, :rate, :nb_comments)

    @name = params[:name]
    @budget = params[:budget]
    @difficulty = params[:difficulty]
    @total_time = params[:total_time]

    @tag_ids = params.fetch("tag_ids", []).compact_blank
    @ingredient_names = params.fetch("ingredient_names", "").split(',')

    @sort_by = params[:sort_by]
    @page = params.fetch("page", 1).to_i
  end

  def call
    search_recipes
    sort_recipes
    paginate_recipes

    @recipes
  end

  private

  def search_recipes
    search_by_name
    search_by_budget
    search_by_difficulty
    search_by_total_time
    search_by_tags
    search_by_ingredients
  end

  def search_by_name
    @recipes = @recipes.where("name ILIKE ?", "%#{@name}%") if @name.present?
  end

  def search_by_budget
    @recipes = @recipes.where(budget: @budget) if @budget.present?
  end

  def search_by_difficulty
    @recipes = @recipes.where(difficulty: @difficulty) if @difficulty.present?
  end

  def search_by_total_time
    @recipes = @recipes.where("total_time <= ?::interval", "#{ChronicDuration.parse(@total_time)} minutes") if @total_time.present?
  end

  def search_by_tags
    @recipes = @recipes.with_tags(@tag_ids) if @tag_ids.any?
  end

  def search_by_ingredients
    @recipes = @recipes.with_ingredients(@ingredient_names) if @ingredient_names.any?
  end

  def sort_recipes
    @recipes = @recipes.order("#{@sort_by} DESC") if @sort_by.present?
  end

  def paginate_recipes
    @recipes = @recipes.page(@page).per(RECIPES_PER_PAGE)
  end
end
