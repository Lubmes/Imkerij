require 'rails_helper'

feature 'Admin kan nieuwe categorieën toevoegen' do
  create_navigation
  let(:admin) { create(:user, :admin) }

  before do
    login_as(admin)
    visit shop_path
    click_link 'nieuwe categorie'
  end

  scenario 'met valide details' do
    fill_in 'Naam', with: 'Kaarsen'
    click_button 'Categorie toevoegen'

    expect(page).to have_content 'Categorie is toegevoegd'
    expect(page).to have_content 'Kaarsen'
  end

  scenario 'met invalide details' do
    fill_in 'Naam', with: ''
    click_button 'Categorie toevoegen'

    expect(page).to have_content 'Categorie is niet toegevoegd.'
    expect(page).to have_content 'moet opgegeven zijn'
  end
end
