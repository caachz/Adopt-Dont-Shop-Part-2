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

  it "I can remove pets from my favorites from /favorites" do

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

  end

  it "When I visit /favorites with no pets favorited, its displays no favorites message" do

    shelter1 = Shelter.create!(name: 'humane society', address: "1234 st", city: 'Denver', state: 'Colorado', zip: "29572")
    snickers = Pet.create!(image: 'https://images-na.ssl-images-amazon.com/images/I/41Q-6cQEOLL._AC_SY400_.jpg', name: 'Snickers', age: 15, sex: 'Female', shelter: shelter1)
    snoop = Pet.create!(image: 'https://www.pinclipart.com/picdir/big/2-21285_clip-art-snoopy-snoop-dogg-charlie-brown-png.png', name: 'Snoop', age: 9, sex: 'Male', shelter: shelter1)

    visit "/favorites"

    expect(page).to have_content("No Favorites")

  end

  it "I can remove all favorites from /favorites by pressing remove all favorites" do

    shelter1 = Shelter.create!(name: 'humane society', address: "1234 st", city: 'Denver', state: 'Colorado', zip: "29572")
    snickers = Pet.create!(image: 'https://images-na.ssl-images-amazon.com/images/I/41Q-6cQEOLL._AC_SY400_.jpg', name: 'Snickers', age: 15, sex: 'Female', shelter: shelter1)
    snoop = Pet.create!(image: 'https://www.pinclipart.com/picdir/big/2-21285_clip-art-snoopy-snoop-dogg-charlie-brown-png.png', name: 'Snoop', age: 9, sex: 'Male', shelter: shelter1)
    visit "/pets/#{snoop.id}"
    click_link("Favorite Pet")
    visit "/pets/#{snickers.id}"
    click_link("Favorite Pet")
    visit "/favorites"
    expect(page).to have_content("Favorites: 2")
    click_link("Remove All Favorites")
    expect(current_path).to eq("/favorites")
    expect(page).to have_content("Favorites: 0")
    expect(page).to have_content("No Favorites")

  end

  it "When a pet is deleted it is also removed from favorites" do

    shelter1 = Shelter.create!(name: 'humane society', address: "1234 st", city: 'Denver', state: 'Colorado', zip: "29572")
    snoop = Pet.create!(image: 'https://www.pinclipart.com/picdir/big/2-21285_clip-art-snoopy-snoop-dogg-charlie-brown-png.png', name: 'Snoop', age: 9, sex: 'Male', shelter: shelter1)

    visit "/pets/#{snoop.id}"

    click_link("Favorite Pet")

    expect(current_path).to eq("/pets/#{snoop.id}")

    click_link("Delete Pet")

    visit "/favorites"

    expect(page).to_not have_content("Snoop")
    expect(page).to have_content("Favorites: 0")
    expect(page).to have_content("No Favorites")
  end
end
