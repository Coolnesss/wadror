require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
    [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple are returned by the API, they are all shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("London").and_return(
    [ Place.new( name:"Guiness Pub", id: 1 ),
     Place.new( name:"Hard Rock Cafe", id: 2 ),
     Place.new( name:"Best place", id: 3 ) ]
    )


    visit places_path
    fill_in('city', with: 'London')
    click_button "Search"

    expect(page).to have_content "Guiness Pub"
    expect(page).to have_content "Hard Rock Cafe"
    expect(page).to have_content "Best place"

  end

  it "if place does not exist, valid response is provided to user" do
    allow(BeermappingApi).to receive(:places_in).with("Tylypahka").and_return(
      []
    )


    visit places_path
    fill_in('city', with: 'Tylypahka')
    click_button "Search"

    expect(page).to have_content "No locations in"

  end
end
