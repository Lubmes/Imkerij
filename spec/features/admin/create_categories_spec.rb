require 'rails_helper'

RSpec.feature 'Admin kan nieuwe categorieën toevoegen', :pending do
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(:admin)
    visit products_path
    click_link 'Nieuwe categorie'
  end

  scenario 'met valide details' do
    fill_in 'Naam', with: 'Kaarsen'
    click_link 'Categorie toevoegen'

    expect(page).to have_content 'Categorie is toegevoegd'
    expect(page).to have_content 'Kaarsen'
  end
end