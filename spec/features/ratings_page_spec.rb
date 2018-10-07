require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:style) {FactoryBot.create :style}
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }


  before :each do
    visit signin_path
    fill_in('username', with:'Pekka')
    fill_in('password', with:'Foobar1')
    click_button('Log in')
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "ratings page" do
    let!(:rating1) {FactoryBot.create(:rating, score: 10, user: user)}
    let!(:rating2) {FactoryBot.create(:rating, score: 20, user: user)}
    let!(:rating3) {FactoryBot.create(:rating, score: 30, user: user)}
    before :each do
      visit ratings_path
    end
    it "all ratings are shown in the ratings page" do
        expect(page).to have_content "#{rating1}" 
        expect(page).to have_content "#{rating2}" 
        expect(page).to have_content "#{rating3}" 
    end

    it "number of ratings is shown" do
      expect(page).to have_content "Number of ratings: 3"
    end
  end
end