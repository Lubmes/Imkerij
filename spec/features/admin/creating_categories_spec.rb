require 'rails_helper'

RSpec.feature 'Admin kan nieuwe categorieën toevoegen' do
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(admin)
    visit categories_path
    click_link 'nieuwe categorie'
  end

  scenario 'met valide details' do
    fill_in 'Naam', with: 'Kaarsen'
    click_button 'Opslaan'

    expect(page).to have_content 'Categorie is toegevoegd'
    expect(page).to have_content 'Kaarsen'
  end
end