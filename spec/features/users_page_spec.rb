require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      visit signin_path
      fill_in('username', with:'Pekka')
      fill_in('password', with:'Foobar1')
      click_button('Log in')

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end
    it "is redirected back to signin form if wrong credentials given" do
        visit signin_path
        fill_in('username', with:'Pekka')
        fill_in('password', with:'wrong')
        click_button('Log in')
  
        expect(current_path).to eq(signin_path)
        expect(page).to have_content 'Username and/or password mismatch'
    end

    describe "while viewing users own page" do
      let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
      let!(:beer) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
      let!(:user1) { FactoryBot.create(:user, username:"eka", password:"Testi1", password_confirmation:"Testi1") }
      let!(:user2) {FactoryBot.create(:user, username: "testi")}
      let!(:rating) { FactoryBot.create(:rating, score: 10, user: user2) }
      let!(:rating2) { FactoryBot.create(:rating, score: 11, user: user1) }
      before :each do
        visit signin_path
        fill_in('username', with:'eka')
        fill_in('password', with:'Testi1')
        click_button('Log in')
        visit user_path(user1)
      end
      
      it "user can view their own ratings" do
        expect(page).to have_content "#{rating2}"
        expect(page).not_to have_content "#{rating}"
      end

      it "user can remove their own rating" do
        expect{
          page.find("li", text:"#{rating2}").click_link('delete')
          }.to change{Rating.count}.from(2).to(1)
      end

      it "shows users favorite brewery" do
        expect(page).to have_content "Favorite brewery: anonymous"
      end

      it "shows users favorite beer style" do
        expect(page).to have_content "Favorite style of beer: Lager"
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
  end
end