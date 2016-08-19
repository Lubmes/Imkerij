require 'rails_helper'

RSpec.feature 'Admin kan categorieën bijwerken', :pending do
  let!(:categorie) { FactoryGirl.create(:categorie, name: 'Kaarsen') }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(:admin)
    visit products_path
  end

  scenario 'met valide details' do
    page.find('div', :text => 'Kaarsen').click_link 'Bijwerken'
    fill_in 'Naam', with: 'Bijenkaarsen'
    click_link 'Categorie bijwerken'

    expect(page).to have_content 'Categorie is bijgewerkt.'
    expect(page).to have_content 'Bijenkaarsen'
  end
end