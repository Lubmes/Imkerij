require 'rails_helper'

RSpec.feature 'Admin kan producten bijwerken' do
  let!(:category) { FactoryGirl.create(:category, name: 'Honing' )}
  let!(:product) { FactoryGirl.create(:product, name: 'Honingpot 200ml',
                                                description: 'Honing uit Veere.',
                                                category: category )}
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(admin)
    visit shop_path
  end

  scenario 'met valide details' do
    page.find('.product', :text => 'Honingpot 200ml').click_link 'BIJWERKEN'
    fill_in 'Naam', with: 'Honingpot 200ml Spec. Edition'
    fill_in 'Omschrijving', with: 'Gelimiteerde uitgave, wees er snel bij!'
    # fill_in 'Prijs', with: 3.50
    click_button 'Opslaan'

    expect(page).to have_content 'Product is bijgewerkt.'
    expect(page).to have_content 'Honingpot 200ml Spec. Edition'
    expect(page).to have_content 'Gelimiteerde uitgave, wees er snel bij!'
    # expect(page).to have_content 3.50
    # expect(page).to have_no_content 2.50 # prijs aanmaken in let
  end
end
