require 'rails_helper'

describe Beer do
  it "can save beer with name and style" do
    beer = Beer.create(name:"BestBeer", style:Style.create(name:"Lager"))

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "cannot save beer with no name" do
    beer = Beer.create(style:Style.create(name:"Lager"))

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "cannot save beer without style" do
    beer = Beer.create(name:"Amazing")

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
