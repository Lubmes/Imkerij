require 'rails_helper'

feature 'User kan bij het afrekenen', js: true do
  create_navigation
  let!(:category) { create(:category, name: 'Honing') }
  let!(:product) { create(:product, name: 'Honingpot 275ml',
                                   price: '3,95',
                                category: category) }

  before do
    visit shop_path
    page.find('.product', :text => 'Honingpot 275ml').click_button('VOEG TOE')
    click_link 'AFREKENEN'
  end

  context 'in zijn bestelling het aantal aanpassen van een besteld product' do
    before do
      within('.selections', :text => 'Honingpot 275ml') do
        fill_in with: 4
        click_button('PAS AAN')
      end
    end
    scenario 'en een gewijzigde totaalprijs zien' do
      within('.selections', :text => 'Honingpot 275ml') do
        expect(page).to have_content '4'
        expect(page).to have_content '€ 15,80'
      end
    end
    scenario 'en nog niet de "Bevestig" knop zien' do
      expect(page).not_to have_content 'Bevestig'
    end
  end

  context 'in zijn persoonsgegevens zijn informatie voor de eerste keer opgeven' do
    before do
      within('.user.registration') do
        fill_in 'E-mail', with: 'test@example.com'
        fill_in 'Wachtwoord', with: 'password'
        fill_in 'Wachtwoord bevestigen', with: 'password'
        fill_in 'Voornaam', with: 'Frans'
        fill_in 'Achternaam', with: 'Timmerman'
        click_button 'Registreer'
      end
    end
    scenario 'zijn naam en order terugzien en een vervolg verzendadres-formulier' do
      expect(page).to have_content 'Timmerman'
      expect(page).to have_content '€ 3,95'
      expect(page).to have_content 'ADRES'
    end
    scenario 'en nog niet de "Bevestig" knop zien' do
      expect(page).not_to have_content 'Bevestig'
    end

    context 'in het vervolg verzendadres-formulier een adres opgeven' do
      before do
        # find('.add-address', :text => 'ADRES').click
        fill_in 'Straat', with: 'Korteweg'
        fill_in 'Huisnummer', with: '12A'
        fill_in 'Postcode', with: '1234AB'
        fill_in 'Woonplaats', with: 'Ons Dorp'
        fill_in 'Land', with: 'Nederland'
        click_button 'Opslaan'
      end
      scenario 'en al zijn bestelling gegevens zien' do
        expect(page).to have_content 'Timmerman'
        expect(page).to have_content '€ 3,95'
        expect(page).to have_content 'Korteweg'
      end
      scenario 'en op "Bevestig" kunnen klikken' do
        click_link 'Bevestig'
        expect(page).to have_content 'Naar de bank'
      end
    end
  end
end
