require 'rails_helper'

RSpec.feature 'User kan afrekenen', :pending do
	let!(:cheap_product) { FactoryGirl.create(:product, name: 'Propolis lollie', price: 0.80) }
  let!(:expensive_product) { FactoryGirl.create(:product, name: 'Honingpot 400ml', price: 3.95) }

  before do
  	visit products_path
  end

  scenario 'met een vol mandje' do
    page.find('li', :text => 'Propolis lollie').click_link('Voeg toe aan winkelwagen')
    page.find('li', :text => 'Honingpot 400ml').click_link('Voeg toe aan winkelwagen')
    click_link 'Afrekenen'

    basket = Basket.last
    expect(page.current_url).to eq basket_url(basket)

    within('#receipt #goods') do
      expect(page).to have_content 'Propolis lollie'
      expect(page).to have_content 0.80
      expect(page).to have_content 'Honingpot 400ml'
      expect(page).to have_content 3.95
    end
    within('#receipt #sum') do
	    expect(page).to have_content 0.80 + 3.95
	  end

    # scenario 'als terugkerende gebruiker' do
    #   login_as user
    #   visit basket_path(basket)
    #   click_link 'Afrekenen'
    #   expect(page).to have_content('Betaalomgeving.')
    # end  
  end
end