require "rails_helper"

RSpec.describe RecipeSearchFormPresenter do
  subject(:presenter) { described_class.new(search_params) }

  let(:search_params) {
    {
      tag_ids: ["1", "2"],
      ingredient_names: "Sucre,Farine",
      budget: "cheap",
      difficulty: "easy",
      total_time: "30",
      sort_by: "rate",
      name: "Gateau au chocolat"
    }
  }

  describe "#tags" do
    let!(:tag_1) { create(:tag) }
    let!(:tag_2) { create(:tag) }

    it "returns an array of tags sorted by name" do
      expected_tags = [[tag_1.name, tag_1.id], [tag_2.name, tag_2.id]]
      expect(presenter.tags).to match_array(expected_tags)
    end
  end

  describe "#budgets" do
    it "returns an array of recipe budgets" do
      expected_budgets = Recipe.budgets.keys.map { |key| [key.humanize, key] }
      expect(presenter.budgets).to eq(expected_budgets)
    end
  end

  describe "#difficulties" do
    it "returns an array of recipe difficulties" do
      expected_difficulties = Recipe.difficulties.keys.map { |key| [key.humanize, key] }
      expect(presenter.difficulties).to eq(expected_difficulties)
    end
  end

  describe "#sort_by" do
    it "returns an array of sort options" do
      expected_sort_by = Recipe::SORT_BY.map { |key| [key.humanize, key] }
      expect(presenter.sort_by).to eq(expected_sort_by)
    end
  end

  describe "selected methods" do
    it "returns the selected tag ids" do
      expect(presenter.selected_tags).to eq(search_params[:tag_ids])
    end

    it "returns the selected ingredient names" do
      expect(presenter.selected_ingredient_names).to eq(search_params[:ingredient_names])
    end

    it "returns the selected budget" do
      expect(presenter.selected_budget).to eq(search_params[:budget])
    end

    it "returns the selected difficulty" do
      expect(presenter.selected_difficulty).to eq(search_params[:difficulty])
    end

    it "returns the selected total time" do
      expect(presenter.selected_total_time).to eq(search_params[:total_time])
    end

    it "returns the selected sort_by option" do
      expect(presenter.selected_sort_by).to eq(search_params[:sort_by])
    end

    it "returns the selected recipe name" do
      expect(presenter.selected_name).to eq(search_params[:name])
    end
  end
end
