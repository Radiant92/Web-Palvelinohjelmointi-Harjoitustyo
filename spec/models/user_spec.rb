require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "with a inproper password won't save" do
    let(:user_short){ User.create username:"Shorty", password:"S1", password_confirmation:"S1" }
    let(:user_alpha){ User.create username:"Alpha", password:"alPha", password_confirmation:"alPha" }

    it "is too short" do
        expect(user_short).not_to be_valid
        expect(User.count).to eq(0)
    end

    it "consists of only the alphabet" do
        expect(user_alpha).not_to be_valid
        expect(User.count).to eq(0)
    end
  end
  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining the favorite_beer" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
        beer = FactoryBot.create(:beer)
        rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
        expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
        create_beer_with_rating({ user: user }, 10 )
        create_beer_with_rating({ user: user}, 7 )
        best = create_beer_with_rating({ user: user }, 25 )
 
        expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining the favorite_style" do
      expect(user).to respond_to(:favorite_style)
    end
  
    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only style if only one rating" do
        create_beer_with_rating_and_style({ user: user }, "IPA", 20)
        expect(user.favorite_style).to eq("IPA")
    end

    it "is the one with highest average if several rated" do
        create_beer_with_rating_and_style({ user: user }, "IPA", 10)
        create_beers_with_many_ratings({ user: user }, 9, 8, 11, 7)
 
        expect(user.favorite_style).to eq("IPA")
    end
  end
  
  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining the favorite_brewery" do
      expect(user).to respond_to(:favorite_brewery)
    end
  
    it "without ratings does not have a favorite brewery" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only brewery if only one rating" do
        create_beer_with_rating_and_brewery({ user: user }, "BrewDog", 10)
        expect(user.favorite_brewery).to eq("BrewDog")
    end

    it "is the one with highest average if several rated" do
        create_beer_with_rating_and_brewery({ user: user }, "BrewDog", 7)
        create_beer_with_rating_and_brewery({ user: user }, "Dog", 9)
        create_beer_with_rating_and_brewery({ user: user }, "BrewDogi", 8)
        expect(user.favorite_brewery).to eq("Dog")
    end
  end
end

def create_beer_with_rating(object, score)
    beer = FactoryBot.create(:beer)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
    beer
end

def create_beers_with_many_ratings(object, *scores)
    scores.each do |score|
      create_beer_with_rating(object, score)
    end
end

def create_beer_with_rating_and_style(object, style, score)
    beer = FactoryBot.create(:beer, style: style)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
end

def create_beer_with_rating_and_brewery(object, brewery_name, score)
    brewery = FactoryBot.create(:brewery, name: brewery_name)
    beer = FactoryBot.create(:beer, brewery: brewery)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
end