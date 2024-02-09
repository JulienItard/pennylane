require "rails_helper"

RSpec.describe Recipe, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should define_enum_for(:budget).with_values([:cheap, :normal, :expensive]) }
    it { should define_enum_for(:difficulty).with_values([:very_easy, :easy, :medium, :hard]) }
  end

  describe "associations" do
    it { should have_many(:recipe_tags) }
    it { should have_many(:tags).through(:recipe_tags) }
    it { should have_many(:ingredients) }
  end

  describe "scopes" do
    describe ".with_tags" do
      let!(:tag1) { create(:tag) }
      let!(:tag2) { create(:tag) }
      let!(:recipe) { create(:recipe, tags: [tag1, tag2]) }

      it "returns recipes with specific tags" do
        expect(Recipe.with_tags([tag1.id, tag2.id])).to include(recipe)
      end

      it "does not return recipes without the specific tags" do
        other_recipe = create(:recipe)
        expect(Recipe.with_tags([tag1.id, tag2.id])).not_to include(other_recipe)
      end
    end

    describe ".with_ingredients" do
      let!(:recipe_with_ingredients) { create(:recipe) }
      let!(:ingredient1) { create(:ingredient, name: "Beurre", recipe: recipe_with_ingredients) }
      let!(:ingredient2) { create(:ingredient, name: "Chocolat", recipe: recipe_with_ingredients) }
      let!(:other_recipe) { create(:recipe) }
      let!(:other_ingredient) { create(:ingredient, name: "Fraise", recipe: other_recipe) }

      it "returns recipes with specific ingredients" do
        matching_recipes = Recipe.with_ingredients(["beurre", "chocolat"])
        expect(matching_recipes).to include(recipe_with_ingredients)
      end

      it "does not return recipes without the specific ingredients" do
        non_matching_recipes = Recipe.with_ingredients(["beurre", "chocolat"])
        expect(non_matching_recipes).not_to include(other_recipe)
      end
    end
  end
end
