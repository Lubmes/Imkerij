require 'rails_helper'

RSpec.feature 'User kan inloggen', :pending do

  scenario 'bij het afrekenen' do
    let!(:basket) { FactoryGirl.create(:basket) } # met producten ! nog toevoegen !

    visit basket_path(basket)
    click_link 'Afrekenen'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Wachtwoord', with: 'password'
    click_button 'Gegevens kloppen'

    expect(page).to have_content('U gaat door naar de betaalomgeving.')
    expect(page).to eq basket_path(basket)
  end

  scenario 'vóór het afrekenen', :pending do
    # in de winkelomgeving ...
  end
end