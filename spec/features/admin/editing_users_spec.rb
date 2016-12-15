require 'rails_helper'

RSpec.feature 'Admin kan gebruikers bijwerken' do
  let!(:user) { FactoryGirl.create(:user, firstname: 'John', 
                                          lastname: 'D.' )}
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(admin)
    visit '/'
    click_link 'admin'
    click_link 'gebruikers'
    page.find('.user', :text => 'John').click_link 'BIJWERKEN'
  end

  scenario 'met valide details' do
    fill_in 'Voornaam', with: 'Johnny'
    fill_in 'Achternaam', with: 'Depp'
    click_button 'Opslaan'

    expect(page).to have_content 'Gebruiker is bijgewerkt.'
    expect(page).to have_content 'Johnny'
    expect(page).to have_content 'Depp'
  end

  scenario 'met invalide details' do
    fill_in 'E-mail', with: ''
    fill_in 'Voornaam', with: ''
    fill_in 'Achternaam', with: ''
    fill_in 'Straat', with: ''
    fill_in 'Huisnummer', with: ''
    fill_in 'Postcode', with: ''
    fill_in 'Woonplaats', with: ''
    fill_in 'Land', with: ''
    click_button 'Opslaan'

    expect(page).to have_content 'Gebruiker is niet bijgewerkt.'
    expect(page).to have_content 'E-mail moet opgegeven zijn.'
    expect(page).to have_content 'Voornaam moet opgegeven zijn.'
    expect(page).to have_content 'Achternaam moet opgegeven zijn.'
    expect(page).to have_content 'Straat moet opgegeven zijn.'
    expect(page).to have_content 'Huisnummer moet opgegeven zijn.'
    expect(page).to have_content 'Postcode moet opgegeven zijn.'
    expect(page).to have_content 'Woonplaats moet opgegeven zijn.'
    expect(page).to have_content 'Land moet opgegeven zijn.'
  end

end