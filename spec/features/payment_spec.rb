require 'rails_helper'

feature 'User kan zijn bestelling afrekenen', js: true do
  create_navigation
  let!(:category)           { create(:category, name: 'Honing') }
  let!(:product)  { create(:product, name: 'Honingpot 275ml',
                                              price: '3,95',
                                           category: category) }

  before do
    visit shop_path
    page.find('.product', :text => 'Honingpot 275ml').click_button('VOEG TOE')
    click_link 'AFREKENEN'
  end

  scenario 'en het aantal aanpassen van een besteld product' do
    product_in_check_out = page.find('.selections', :text => 'Honingpot 275ml')
    product_in_check_out.fill_in with: 4
    product_in_check_out.click_button('PAS AAN')

    expect(product_in_check_out).to have_content '4'
    expect(page).to have_content '€ 15,80'
  end

  scenario 'en zijn persoonsgegevens opgeven voor de eerste keer' do
    within('.user.registration') do
      fill_in 'E-mail', with: 'test@example.com'
      fill_in 'Wachtwoord', with: 'password'
      fill_in 'Wachtwoord bevestigen', with: 'password'
      fill_in 'Voornaam', with: 'Frans'
      fill_in 'Achternaam', with: 'Timmerman'
      click_button 'Registreer'
    end

    expect(page).to have_content 'Timmerman'
    expect(page).to have_content '€ 3,95'
    expect(page).to have_content 'Straat'

    fill_in 'Straat', with: 'Korteweg'
    fill_in 'Huisnummer', with: '12A'
    fill_in 'Postcode', with: '1234AB'
    fill_in 'Woonplaats', with: 'Ons Dorp'
    fill_in 'Land', with: 'Nederland'
    click_button 'Opslaan'

    expect(page).to have_content 'Timmerman'
    expect(page).to have_content '€ 3,95'
    expect(page).to have_content 'Korteweg'
  end
end
