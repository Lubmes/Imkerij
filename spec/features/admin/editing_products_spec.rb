require 'rails_helper'

RSpec.feature 'Admin kan producten bijwerken', :pending do
  let!(:product) { FactoryGirl.create(:product, name: 'Honingpot 200ml', 
                                                description: 'Honing uit Veere.', 
                                                price: 2.50) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(:admin)
    visit products_path
  end

  scenario 'met valide details' do
    page.find('li', :text => 'Honingpot 200ml').click_link 'Bijwerken'
    fill_in 'Naam', with: 'Honingpot 200ml Spec. Edition'
    fill_in 'Omschrijving', with: 'Gelimiteerde uitgave, wees er snel bij!'
    fill_in 'Prijs', with: 3.50

    expect(page).to have_content 'Product is bijgewerkt.'
    expect(page).to have_content 'Honingpot 200ml Spec. Edition'
    expect(page).to have_content 'Gelimiteerde uitgave, wees er snel bij!'
    expect(page).to have_content 3.50
    expect(page).to have_no_content 2.50
  end
end