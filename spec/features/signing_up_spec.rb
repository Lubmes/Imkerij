require 'rails_helper'

feature 'User kan zich aanmelden' do

  scenario 'in de winkel' do
    visit shop_path
    click_link 'nieuwe account'
    fill_in 'E-mail', with: 'test@example.com'
    fill_in 'Wachtwoord', with: 'password'
    fill_in 'Wachtwoord bevestigen', with: 'password'
    fill_in 'Voornaam', with: 'Frans'
    fill_in 'Achternaam', with: 'Timmerman'
    click_button 'Registreer'

    expect(page).to have_content('U bent ingeschreven.')
    expect(page).to have_current_path(shop_path)
  end

end
