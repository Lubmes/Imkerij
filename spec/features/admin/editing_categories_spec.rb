require 'rails_helper'

feature 'Admin kan categorieën bijwerken' do
  let!(:category) { create(:category, name: 'Kaarsen') }
  let(:admin)     { create(:user, :admin) }

  before do
    login_as(admin)
    visit shop_path
  end

  scenario 'met valide details' do
    page.find('.category', :text => 'Kaarsen').click_link 'bijwerken'
    fill_in 'Naam', with: 'Bijenkaarsen'
    click_button 'Categorie bijwerken'

    expect(page).to have_content 'Categorie is bijgewerkt.'
    expect(page).to have_content 'Bijenkaarsen'
  end
end
