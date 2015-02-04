require 'rails_helper'

#include OwnTestHelper

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "with ratings" do


    it "can see their own ratings on user page" do

      brewery =  FactoryGirl.create :brewery, name:"Koff"
      beer1 =  FactoryGirl.create :beer, name:"iso 3", brewery:brewery
      expect(Beer.all.first.name).to eq("iso 3")
      beer2 =  FactoryGirl.create :beer, name:"Karhu", brewery:brewery

      user2 = FactoryGirl.create :user, username:"asdffggg"
      user = FactoryGirl.create :user, username:"paras"
      sign_in(username:"paras", password:"Foobar1")

      FactoryGirl.create(:rating, beer:beer1, user:user)
      FactoryGirl.create(:rating, beer:beer2, user:user2)

      visit user_path(user)

      expect(page).to have_content "This user has made 1 rating"
      expect(page).to have_content "iso 3"
      expect(page).not_to have_content "Karhu"

    end

    it "can remove their own rating" do
      user = FactoryGirl.create :user, username:"paras"
      sign_in(username:"paras", password:"Foobar1")

      beer1 = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer1, user:user)

      visit user_path(user)

      page.first(:link, "Delete").click

      expect(user.ratings.count).to eq(0)
    end
  end

end
