class RecipeSearchFormPresenter
  def initialize(search_params = {})
    @search_params = search_params
  end

  def tags
    Tag.order(:name).map { |tag| [tag.name, tag.id] }
  end

  def budgets
    Recipe.budgets.map { |key, value| [key.humanize, key] }
  end

  def difficulties
    Recipe.difficulties.map { |key, value| [key.humanize, key] }
  end

  def sort_by
    Recipe::SORT_BY.map { |key, value| [key.humanize, key] }
  end

  def selected_tags
    @search_params[:tag_ids]
  end

  def selected_ingredient_names
    @search_params[:ingredient_names]
  end

  def selected_budget
    @search_params[:budget]
  end

  def selected_difficulty
    @search_params[:difficulty]
  end

  def selected_total_time
    @search_params[:total_time]
  end

  def selected_sort_by
    @search_params[:sort_by]
  end

  def selected_total_time
    @search_params[:total_time]
  end

  def selected_ingredient_names
    @search_params[:ingredient_names]
  end

  def selected_name
    @search_params[:name]
  end
end
