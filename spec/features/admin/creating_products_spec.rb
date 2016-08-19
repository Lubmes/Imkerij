require 'rails_helper'

RSpec.feature 'Admin kan nieuwe producten toevoegen', :pending do
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(:admin)
    visit products_path
    click_link 'Nieuw product'
  end

  scenario 'met valide details' do
    fill_in 'Naam', with: 'Propolis lollie'
    fill_in 'Omschrijving', with: 'Een lollie van propolis. Propolis heeft gigantisch veel gezonde eigenschappen.'
    fill_in 'Prijs', with: 0.80

    expect(page).to have_content 'Product is toegevoegd'
    expect(page).to have_content 'Propolis lollie'
    expect(page).to have_content 0.80
  end
end