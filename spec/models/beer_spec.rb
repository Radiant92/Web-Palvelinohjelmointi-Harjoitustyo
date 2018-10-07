require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:brewery) { Brewery.create name: "test", year: 2000 }
  let(:style) {Style.create name: "Lager", description: "jtn"}
  let(:beer){ Beer.new name:"Beerbert", style: style, brewery:brewery }

  it "has the name set correctly" do
    expect(beer.name).to eq("Beerbert")
  end

  it "has the style set correctly" do
    expect(beer.style.name).to eq("Lager")
  end

  it "has the brewery id set correctly" do
    expect(beer.brewery).to eq(brewery)
  end

  describe "with a proper beer" do
    let(:brewery) { Brewery.create name: "test", year: 2000 }
    let(:style) {Style.create name: "Lager", description: "jtn"}
    let(:beer){ Beer.create name:"Beerbert", style:style, brewery:brewery }

    it "is saved" do
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end

  describe "won't save with a inproper beer" do
    let(:brewery) { Brewery.new name: "test", year: 2000 }
    let(:style2) {Style.create name: "Lager", description: "jtn"}
    let(:test_no_style) { Beer.create name:"noStyle", style: nil, brewery:brewery }
    let(:test_no_name) { Beer.create name:"", style:style2, brewery:brewery }

    it "has no name" do
      expect(test_no_name).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "has no style" do
      expect(test_no_style).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end
end
