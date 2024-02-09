require "rails_helper"

RSpec.describe Tag, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe "associations" do
    it { should have_many(:recipe_tags) }
    it { should have_many(:recipes).through(:recipe_tags) }
  end
end
