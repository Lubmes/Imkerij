require 'rails_helper'

RSpec.feature 'Admins kan nieuwe gebruikers toevoegen' do
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(admin)
    visit '/admin'
    click_link 'gebruikers'
    click_link 'nieuwe gebruiker'
  end

  scenario 'met valide details' do
    fill_in 'E-mail', with: 'newbie@example.com'
    fill_in 'Wachtwoord', with: 'password'
    fill_in 'Voornaam', with: 'Jan'
    fill_in 'Achternaam', with: 'Jagerman'
    fill_in 'Straat', with: 'Jaagpad'
    fill_in 'Huisnummer', with: '23'
    fill_in 'Postcode', with: '1234AB'
    fill_in 'Woonplaats', with: 'Middelburg'
    fill_in 'Land', with: 'Nederland'
    click_button 'Opslaan'

    expect(page).to have_content 'Gebruiker is toegevoegd.'
  end

  scenario 'als de nieuwe gebruiker een admin is' do
    fill_in 'E-mail', with: 'admin@example.com'
    fill_in 'Wachtwoord', with: 'password'
    fill_in 'Voornaam', with: 'Jan'
    fill_in 'Achternaam', with: 'Jagerman'
    fill_in 'Straat', with: 'Jaagpad'
    fill_in 'Huisnummer', with: '23'
    fill_in 'Postcode', with: '1234AB'
    fill_in 'Woonplaats', with: 'Middelburg'
    fill_in 'Land', with: 'Nederland'
    # Adminrechten
    check 'Adminrechten'
    click_button 'Opslaan'

    expect(page).to have_content 'Gebruiker is toegevoegd.'
    expect(page).to have_content 'Adminrechten Ja'
  end
end