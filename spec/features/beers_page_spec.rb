require 'rails_helper'

describe "Beers page" do
    let!(:brewery){ FactoryBot.create(:brewery) }
    let!(:style){ FactoryBot.create(:style) }
    let!(:user){ FactoryBot.create(:user) }
    before :each do
        visit signin_path
        fill_in('username', with:'Pekka')
        fill_in('password', with:'Foobar1')
        click_button('Log in')
    end
    
    it "new beer has a valid (not empty) name" do
        visit new_beer_path
        fill_in('Name', with:'Beer')
        select('Lager', from:'beer[style_id]')
        select('anonymous', from:'beer[brewery_id]')

        expect{
            click_button "Create Beer"
          }.to change{Beer.count}.from(0).to(1)
        
    end

    it "invalid beers wont be saved, but will prompt an error message" do
        visit new_beer_path
        fill_in('Name', with:'')
        select('Lager', from:'beer[style_id]')
        select('anonymous', from:'beer[brewery_id]')
        click_button "Create Beer"
        expect(Beer.count).to eq(0)
        expect(page).to have_content "Name can't be blank"
    end
end