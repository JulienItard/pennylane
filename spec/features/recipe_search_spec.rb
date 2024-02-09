require "rails_helper"

RSpec.feature "Recipe Search", type: :feature do
  let!(:recipe1) { create(:recipe, name: "Gateau au chocolat", budget: "cheap", difficulty: "easy", total_time: 1800) }
  let!(:recipe2) { create(:recipe, name: "Tagliatelle carbonara", budget: "expensive", difficulty: "hard", total_time: 3600) }
  let!(:tag1) { create(:tag, name: "Dessert") }
  let!(:tag2) { create(:tag, name: "Pâte") }
  let!(:ingredient1) { create(:ingredient, name: "Chocolat", recipe: recipe1) }
  let!(:ingredient2) { create(:ingredient, name: "Lardon", recipe: recipe2) }

  before do
    recipe1.tags << tag1
    recipe2.tags << tag2
  end

  scenario "User filters recipes by busget" do
    visit search_recipes_path
    select "Cheap", from: "budget"
    click_button "Recherche"

    expect(page).to have_content("Gateau au chocolat")
    expect(page).to_not have_content("Tagliatelle carbonara")
  end

  scenario "User filters recipes by difficulty" do
    visit search_recipes_path
    select "Easy", from: "difficulty"
    click_button "Recherche"

    expect(page).to have_content("Gateau au chocolat")
    expect(page).to_not have_content("Tagliatelle carbonara")
  end

  scenario "User filters recipes by total time" do
    visit search_recipes_path
    fill_in "total_time", with: "45"
    click_button "Recherche"

    expect(page).to have_content("Gateau au chocolat")
    expect(page).to_not have_content("Tagliatelle carbonara")
  end

  scenario "User searches recipes by tags" do
    visit search_recipes_path

    select "Dessert", from: "tag_ids"
    click_button "Recherche"

    expect(page).to have_content("Gateau au chocolat")
    expect(page).to_not have_content("Tagliatelle carbonara")
  end

  scenario "User searches recipes by ingredients" do
    visit search_recipes_path
    fill_in "ingredient_names", with: "Chocolat"
    click_button "Recherche"

    expect(page).to have_content("Gateau au chocolat")
    expect(page).to_not have_content("Tagliatelle carbonara")
  end

  scenario "User combines multiple search criteria" do
    visit search_recipes_path
    fill_in "name", with: "Gateau"
    select "Cheap", from: "budget"
    select "Easy", from: "difficulty"
    fill_in "total_time", with: "45"

    click_button "Recherche"

    expect(page).to have_content("Gateau au chocolat")
    expect(page).to_not have_content("Tagliatelle carbonara")
  end
end
