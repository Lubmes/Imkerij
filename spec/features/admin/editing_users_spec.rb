require 'rails_helper'

RSpec.feature 'Admin kan gebruikers bijwerken' do
  let!(:user) { create(:user, first_name: 'John',
                               last_name: 'D.' )}
  let(:admin) { create(:user, :admin) }

  before do
    login_as(admin)
    visit '/admin'
    click_link 'gebruikers'
    page.find('.user', :text => 'John').click_link 'bijwerken'
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
    click_button 'Opslaan'

    expect(page).to have_content 'Gebruiker is niet bijgewerkt.'
    expect(page).to have_content 'E-mail moet opgegeven zijn.'
    expect(page).to have_content 'Voornaam moet opgegeven zijn.'
    expect(page).to have_content 'Achternaam moet opgegeven zijn.'
  end

end
