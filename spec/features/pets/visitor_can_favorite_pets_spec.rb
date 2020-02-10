require "rails_helper"

RSpec.describe "Visitor can favorite and view their favorites" do
  it "sees total of favorited pets at the top of every page" do

    visit "/pets"

    expect(page).to have_content("Favorites: 0")

    visit "/shelters"

    expect(page).to have_content("Favorites: 0")
  end

  it "Can add pets to favorite list" do
    shelter1 = Shelter.create!(name: 'humane society', address: "1234 st", city: 'Denver', state: 'Colorado', zip: "29572")
    snickers = Pet.create!(image: 'https://images-na.ssl-images-amazon.com/images/I/41Q-6cQEOLL._AC_SY400_.jpg', name: 'Snickers', age: 15, sex: 'Female', shelter: shelter1)

    visit "/pets/#{snickers.id}"

    expect(page).to have_link("Favorite Pet")

    expect(page).to have_content("Favorites: 0")

    click_link("Favorite Pet")

    expect(current_path).to eq("/pets/#{snickers.id}")

    expect(page).to have_content("Favorites: 1")
    expect(page).to have_content("#{snickers.name} has been added to your favorites")
  end

  it "can show all of the favorited pets at /favorites" do
    shelter1 = Shelter.create!(name: 'humane society', address: "1234 st", city: 'Denver', state: 'Colorado', zip: "29572")
    snickers = Pet.create!(image: 'https://images-na.ssl-images-amazon.com/images/I/41Q-6cQEOLL._AC_SY400_.jpg', name: 'Snickers', age: 15, sex: 'Female', shelter: shelter1)
    snoop = Pet.create!(image: 'https://www.pinclipart.com/picdir/big/2-21285_clip-art-snoopy-snoop-dogg-charlie-brown-png.png', name: 'Snoop', age: 9, sex: 'Male', shelter: shelter1)
    visit "/pets/#{snoop.id}"
    click_link("Favorite Pet")
    expect(current_path).to eq("/pets/#{snoop.id}")
    visit "/favorites"
    expect(page).to have_content("Snoop")
    click_link("Snoop")
    expect(current_path).to eq("/pets/#{snoop.id}")
  end

  it "can click the favorites indicator on any page and be taken to /favorites" do
    shelter1 = Shelter.create!(name: 'humane society', address: "1234 st", city: 'Denver', state: 'Colorado', zip: "29572")
    snickers = Pet.create!(image: 'https://images-na.ssl-images-amazon.com/images/I/41Q-6cQEOLL._AC_SY400_.jpg', name: 'Snickers', age: 15, sex: 'Female', shelter: shelter1)
    snoop = Pet.create!(image: 'https://www.pinclipart.com/picdir/big/2-21285_clip-art-snoopy-snoop-dogg-charlie-brown-png.png', name: 'Snoop', age: 9, sex: 'Male', shelter: shelter1)
    visit "/pets/#{snoop.id}"
    click_link("Favorite Pet")
    expect(current_path).to eq("/pets/#{snoop.id}")
    visit "/pets"
    click_link("Favorites")
    expect(current_path).to eq("/favorites")
  end

  it "after I favorite a pet, the favorite link is replaced by a remove favorite link" do

    shelter1 = Shelter.create!(name: 'humane society', address: "1234 st", city: 'Denver', state: 'Colorado', zip: "29572")
    snickers = Pet.create!(image: 'https://images-na.ssl-images-amazon.com/images/I/41Q-6cQEOLL._AC_SY400_.jpg', name: 'Snickers', age: 15, sex: 'Female', shelter: shelter1)
    snoop = Pet.create!(image: 'https://www.pinclipart.com/picdir/big/2-21285_clip-art-snoopy-snoop-dogg-charlie-brown-png.png', name: 'Snoop', age: 9, sex: 'Male', shelter: shelter1)

    visit "/pets/#{snoop.id}"
    click_link("Favorite Pet")
    expect(current_path).to eq("/pets/#{snoop.id}")
    expect(page).to_not have_link("Favorite Pet")
    expect(page).to have_link("Remove Favorite")
    click_link("Remove Favorite")
    expect(current_path).to eq("/pets/#{snoop.id}")
    expect(page).to have_content("Pet removed from favorites")
    expect(page).to have_content("Favorites: 0")

  end

  it "When I visit the favorites page, I see a link to remove pets" do

    shelter1 = Shelter.create!(name: 'humane society', address: "1234 st", city: 'Denver', state: 'Colorado', zip: "29572")
    snickers = Pet.create!(image: 'https://images-na.ssl-images-amazon.com/images/I/41Q-6cQEOLL._AC_SY400_.jpg', name: 'Snickers', age: 15, sex: 'Female', shelter: shelter1)
    snoop = Pet.create!(image: 'https://www.pinclipart.com/picdir/big/2-21285_clip-art-snoopy-snoop-dogg-charlie-brown-png.png', name: 'Snoop', age: 9, sex: 'Male', shelter: shelter1)

    visit "/pets/#{snoop.id}"
    click_link("Favorite Pet")

    visit "/favorites"
    expect(page).to have_content("Snoop")
    expect(page).to have_link("Remove Favorite")
    click_link("Remove Favorite")
    expect(current_path).to eq("/favorites")
    expect(page).to_not have_content("Snoop")
    expect(page).to have_content("Favorites: 0")
    # User Story 13, Remove a Favorite from Favorites Page

    # As a visitor
    # When I have added pets to my favorites list
    # And I visit my favorites page ("/favorites")
    # Next to each pet, I see a button or link to remove that pet from my favorites
    # When I click on that button or link to remove a favorite
    # A delete request is sent to "/favorites/:pet_id"
    # And I'm redirected back to the favorites page where I no longer see that pet listed
    # And I also see that the favorites indicator has decremented by 1
  end
end
