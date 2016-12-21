require 'rails_helper'

RSpec.feature 'User kan zijn mandje vullen', js: true do
  let!(:category) { FactoryGirl.create(:category, name: 'Honing') }
  let!(:cheap_product) { FactoryGirl.create(:product, name: 'Propolis lollie', 
                                                      price: '0,80',
                                                      category: category) }
  let!(:expensive_product) { FactoryGirl.create(:product, name: 'Honingpot 400ml', 
                                                          price: '3,95',
                                                          category: category) }

  before do
    visit categories_path
  end

  scenario 'met verschillende producten' do
    page.find('.product', :text => 'Propolis lollie').click_button('VOEG TOE AAN MANDJE')
    page.find('.product', :text => 'Honingpot 400ml').click_button('VOEG TOE AAN MANDJE')

    within('#order') do
      expect(page).to have_content 'Propolis lollie'
      expect(page).to have_content 'Honingpot 400ml'
      expect(page).to have_content 0.80 + 3.95
    end
  end

  scenario 'met meerde producten van 1 soort' do
    product_from_shop = page.find('.product', :text => 'Propolis lollie')
    product_from_shop.fill_in 'Aantal', with: 5
    product_from_shop.click_button('VOEG TOE AAN MANDJE')
    
    within('#order') do
      product_in_basket = page.find('.booking', :text => 'Propolis lollie')
      expect(product_in_basket).to have_content '5'
      expect(page).to have_content 0.80 * 5
    end
  end

  xcontext 'en na het vullen' do
    scenario 'opslaan' do
      
    end

    scenario 'leegmaken' do

    end
  end
end