require "rails_helper"

RSpec.describe Ingredient, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "associations" do
    it { should belong_to(:recipe) }
  end
end
