require 'rails_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end

  it "cannot save password with small length" do
    user = User.create username:"Pekka", password:"asd", password_confirmation:"asd"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "cannot have a password with no digits" do
    user = User.create username:"Pekka", password:"onlyletters", password_confirmation:"onlyletters"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)

  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      rating = Rating.new score:10
      rating2 = Rating.new score:20

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favourite style" do
    it "with multiple ratings has the most common" do

      user = FactoryGirl.create(:user)

      beer1 = Beer.create name: "1", style:"Porter"
      beer2 = Beer.create name: "2", style:"Lager"
      beer3 = Beer.create name: "3", style:"Porter"
      beer4 = Beer.create name: "4", style:"Porter"
      # pitäisi tulla lager
      rating = FactoryGirl.create(:rating, beer:beer1, user:user) #10
      rating2 = FactoryGirl.create(:rating3, beer:beer2, user:user) #17
      rating3 = FactoryGirl.create(:rating4, beer:beer3, user:user) #30
      rating4 = FactoryGirl.create(:rating, beer:beer4, user:user) #10
      expect(user.favourite_style).to eq(beer2.style)
    end
  end
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating score, user
  end
end

def create_beer_with_rating(score,  user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score,  beer:beer, user:user)
  beer
end
