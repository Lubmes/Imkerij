require 'rails_helper'

RSpec.feature 'User kan zich aanmelden' do

  xscenario 'bij het voor de eerste keer afrekenen', :pending do
    let!(:basket) { FactoryGirl.create(:basket) } # met producten ! nog toevoegen !

    visit basket_path(basket)
    click_link 'Afrekenen'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Wachtwoord', with: 'password'
    fill_in 'Wachtwoord bevestigen', with: 'password'
    fill_in 'Straat', with: 'Korteweg'
    fill_in 'Nummer', with: '12A'
    fill_in 'Postcode', with: '1234AB'
    fill_in 'Plaats', with: 'Ons Dorp'
    click_button 'Regristreer'

    expect(page).to have_content('Je bent succesvol ingelogd.')
    expect(page).to eq basket_path(basket)
  end

  scenario 'in de winkel' do
    visit categories_path
    click_link 'nieuwe account'
    fill_in 'E-mail', with: 'test@example.com'
    fill_in 'Wachtwoord', with: 'password'
    fill_in 'Wachtwoord bevestigen', with: 'password'
    fill_in 'Voornaam', with: 'Frans'
    fill_in 'Achternaam', with: 'Timmerman'
    fill_in 'Straat', with: 'Korteweg'
    fill_in 'Huisnummer', with: '12A'
    fill_in 'Postcode', with: '1234AB'
    fill_in 'Woonplaats', with: 'Ons Dorp'
    fill_in 'Land', with: 'Nederland'
    click_button 'Regristreer'

    expect(page).to have_content('U bent ingeschreven.')
    expect(page).to eq categories_path
  end

end