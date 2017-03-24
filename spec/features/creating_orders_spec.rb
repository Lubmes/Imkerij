require 'rails_helper'

feature 'User kan zijn bestelling aanmaken', js: true do
  create_navigation
  let!(:category)           { create(:category, name: 'Honing') }
  let!(:cheap_product)      { create(:product, name: 'Propolis lollie',
                                              price: '0,80',
                                           category: category) }
  let!(:expensive_product)  { create(:product, name: 'Honingpot 400ml',
                                              price: '3,95',
                                           category: category) }

  before do
    visit shop_path
  end

  scenario 'met verschillende producten' do
    page.find('.product', :text => 'Propolis lollie').click_button('VOEG TOE')
    page.find('.product', :text => 'Honingpot 400ml').click_button('VOEG TOE')

    within('#order') do
      expect(page).to have_content 'Propolis lollie'
      expect(page).to have_content 'Honingpot 400ml'
      expect(page).to have_content '€ 4,75'
    end
  end

  scenario 'met meerde producten van 1 soort' do
    product_from_shop = page.find('.product', :text => 'Propolis lollie')
    product_from_shop.fill_in with: 5
    product_from_shop.click_button('VOEG TOE')

    within('#order') do
      product_in_basket = page.find('.bookings', :text => 'Propolis lollie')
      expect(product_in_basket).to have_content '5'
      expect(page).to have_content '€ 4,00'
    end
  end
end
