require "rails_helper"

RSpec.describe RecipesController, type: :controller do
  describe "GET #show" do
    let(:recipe) { create(:recipe) }

    before do
      get :show, params: { id: recipe.id }
    end

    it "assigns @recipe" do
      expect(assigns(:recipe)).to eq(recipe)
    end

    it "renders the show template" do
      expect(response).to render_template(:show)
    end
  end

  describe "GET #search" do
    let!(:recipe) { create(:recipe, name: "Chocolat") }
    let(:search_params) { { name: "Chocolat" } }

    before do
      get :search, params: search_params
    end

    it "assigns @recipes" do
      expect(assigns(:recipes)).to include(recipe)
    end

    it "initializes RecipeSearchFormPresenter with search parameters" do
      expect(assigns(:recipe_search_form_presenter)).to be_a(RecipeSearchFormPresenter)
    end

    it "renders the search template" do
      expect(response).to render_template(:search)
    end
  end
end
