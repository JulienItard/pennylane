require "rails_helper"

RSpec.describe RecipeSearchService do
  describe "#call" do
    let!(:recipe_1) { create(:recipe, name: "Gateau au chocolat", budget: "cheap", difficulty: "easy", total_time: 1800, rate: 4.5, nb_comments: 2) }
    let!(:recipe_2) { create(:recipe, name: "Gauffre", budget: "expensive", difficulty: "hard", total_time: 3600, rate: 5.0, nb_comments: 10) }

    context "when searching by name" do
      subject(:service) { described_class.new(name: "Chocolat") }

      it "returns recipes that match the name" do
        expect(service.call).to include(recipe_1)
        expect(service.call).not_to include(recipe_2)
      end
    end

    context "when filtering by budget" do
      subject(:service) { described_class.new(budget: "cheap") }

      it "returns recipes that match the budget" do
        expect(service.call).to include(recipe_1)
        expect(service.call).not_to include(recipe_2)
      end
    end

    context "when filtering by difficulty" do
      subject(:service) { described_class.new(difficulty: "easy") }

      it "returns recipes that match the difficulty level" do
        expect(service.call).to include(recipe_1)
        expect(service.call).not_to include(recipe_2)
      end
    end

    context "when filtering by total time" do
      subject(:service) { described_class.new(total_time: "45") }

      it "returns recipes with a total time less than or equal to the specified time" do
        expect(service.call).to include(recipe_1)
        expect(service.call).not_to include(recipe_2)
      end
    end

    context "when searching by tags" do
      let!(:tag1) { create(:tag) }
      let!(:tag2) { create(:tag) }

      before do
        recipe_1.tags << tag1
        recipe_2.tags << tag2
      end

      subject(:service) { described_class.new({"tag_ids" => [tag1.id.to_s]}) }

      it "returns recipes that include the specified tags" do
        expect(service.call).to include(recipe_1)
        expect(service.call).not_to include(recipe_2)
      end
    end

    context "when searching by ingredients" do
      let!(:ingredient1) { create(:ingredient, name: "Chocolat", recipe: recipe_1) }
      let!(:ingredient2) { create(:ingredient, name: "Sucre", recipe: recipe_2) }
      subject(:service) { described_class.new({"ingredient_names" => "Chocolat"}) }

      it "returns recipes that include the specified ingredients" do
        expect(service.call).to include(recipe_1)
        expect(service.call).not_to include(recipe_2)
      end
    end

    context "when sorting by rate" do
      subject(:service) { described_class.new(sort_by: "rate") }

      it "returns recipes ordered by rate descending" do
        results = service.call
        expect(results.first).to eq(recipe_2)
        expect(results.second).to eq(recipe_1)
      end
    end

    context "when paginating results" do
      subject(:service) { described_class.new(page: 1) }

      before do
        create_list(:recipe, 15) # Assuming RECIPES_PER_PAGE is 12
      end

      it "returns a limited number of recipes per page" do
        expect(service.call.size).to eq(RecipeSearchService::RECIPES_PER_PAGE)
      end
    end
  end
end
