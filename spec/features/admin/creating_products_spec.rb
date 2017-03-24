require 'rails_helper'

feature 'Admin kan nieuwe producten toevoegen' do
  create_navigation
  let!(:category) { create(:category, name: 'Snoep') }
  let(:admin)     { create(:user, :admin) }

  before do
    login_as(admin)
    visit shop_path
    click_link 'nieuw product'
  end

  scenario 'met valide details' do
    fill_in 'Naam', with: 'Propolis lollie'
    fill_in 'Omschrijving', with: 'Een lollie van propolis. Propolis heeft gigantisch veel gezonde eigenschappen.'
    fill_in 'Prijs', with: '0,80'
    fill_in 'Verzendgewicht', with: 10

    click_button 'Product toevoegen'

    expect(page).to have_content 'Product is toegevoegd'
    expect(page).to have_content 'Propolis lollie'
    # expect(page).to have_content 0.80
  end

  scenario 'met invalide details' do
    fill_in 'Naam', with: ''
    fill_in 'Omschrijving', with: ''
    # fill_in 'Prijs', with: ''
    click_button 'Product toevoegen'

    expect(page).to have_content 'Product is niet toegevoegd'
    expect(page).to have_content 'moet opgegeven zijn'
    expect(page).to have_content 'moet opgegeven zijn'
    # expect(page).to have_content '...' # iets met de prijs
  end
end
