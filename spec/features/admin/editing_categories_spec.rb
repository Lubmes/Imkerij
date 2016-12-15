require 'rails_helper'

RSpec.feature 'Admin kan categorieën bijwerken' do
  let!(:category) { FactoryGirl.create(:category, name: 'Kaarsen') }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(admin)
    visit categories_path
  end

  scenario 'met valide details' do
    page.find('.category', :text => 'Kaarsen').click_link 'BIJWERKEN'
    fill_in 'Naam', with: 'Bijenkaarsen'
    click_button 'Opslaan'

    expect(page).to have_content 'Categorie is bijgewerkt.'
    expect(page).to have_content 'Bijenkaarsen'
  end
end