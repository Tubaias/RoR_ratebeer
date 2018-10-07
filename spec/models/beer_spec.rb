require 'rails_helper'

RSpec.describe Beer, type: :model do
  describe "with a proper brewery" do
    let(:test_brewery) { FactoryBot.create :brewery }
    let(:style) { FactoryBot.create :style }

    it "is saved with a name and style" do
      beer = Beer.new name:"testbeer"
      style.beers << beer
      test_brewery.beers << beer

      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end

    it "is not saved without a name" do
      beer = Beer.new
      style.beers << beer
      test_brewery.beers << beer

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "is not saved without a style" do
      beer = Beer.new name:"testbeer"
      test_brewery.beers << beer

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end
end
