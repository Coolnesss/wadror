require 'rails_helper'

describe "Beer" do
  it "can add beer with valid name" do
    visit new_beer_path


    fill_in('beer_name', with:'Amazing')


    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)

  end

  it "cannot add beer with invalid name and redirects correctly" do
    visit new_beer_path


    click_button "Create Beer"

    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to be(0)
  end

end
