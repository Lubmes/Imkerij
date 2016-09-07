require 'rails_helper'

RSpec.feature 'User kan inloggen' do
  let(:user) { FactoryGirl.create(:user) }

  xscenario 'bij het afrekenen' do
    let!(:basket) { FactoryGirl.create(:basket) } # met producten ! nog toevoegen !

    visit basket_path(basket)
    click_link 'Afrekenen'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Wachtwoord', with: 'password'
    click_button 'Gegevens kloppen'

    expect(page).to have_content('U gaat door naar de betaalomgeving.')
    expect(page).to eq basket_path(basket)
  end

  scenario 'vóór het afrekenen' do
    # in de winkelomgeving ...
    visit '/categories' # MAAK HIER PRODUCTS VAN
    click_link 'inloggen'
    fill_in "E-mail", with: user.email
    fill_in "Wachtwoord", with: "password"
    click_button "Log in"

    expect(page).to have_content "U bent succesvol ingelogd."
    expect(page).to have_content "Ingelogd als #{user.email}"
  end
end