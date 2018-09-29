require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
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

  describe "when exist" do
    let!(:rating1) { Rating.create score:10, beer:beer1, user:user }
    let!(:rating2) { Rating.create score:22, beer:beer2, user:user }

    it "are listed and counted on ratings index page" do
      visit ratings_path

      expect(page).to have_content "Total number of ratings: 2"
      expect(page).to have_content "#{beer1.name} #{rating1.score}"
      expect(page).to have_content "#{beer2.name} #{rating2.score}"
    end

    it "are listed and counted on creator's userpage" do
      user2 = FactoryBot.create :user, username: "another"
      rating3 = Rating.create score:40, beer:beer1, user:user2
      visit user_path(user)

      expect(page).to have_content "Has made 2 ratings"
      expect(page).to have_content "#{beer1.name} #{rating1.score}"
      expect(page).to have_content "#{beer2.name} #{rating2.score}"
      expect(page).not_to have_content "#{beer1.name} #{rating3.score}"
    end

    it "can be deleted by creator" do
      visit user_path(user)
      find_link("delete", options = { href: "/ratings/2" } ).click

      expect(beer1.ratings.count).to eq(1)
      expect(beer2.ratings.count).to eq(0)
    end
  end
end