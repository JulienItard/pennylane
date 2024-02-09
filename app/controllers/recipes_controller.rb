class RecipesController < ApplicationController

  def show
    @recipe = Recipe.includes(:tags, :ingredients).find(params[:id])
  end

  def search
    @recipes = RecipeSearchService.new(params).call
    @recipe_search_form_presenter = RecipeSearchFormPresenter.new(params)
  end
end
