require 'rails_helper'

feature 'User kan inloggen' do
  let(:user) { create(:user) }

  xscenario 'bij het afrekenen' do
    let!(:basket) { create(:basket) } # met producten ! nog toevoegen !

    visit basket_path(basket)
    click_link 'Afrekenen'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Wachtwoord', with: 'password'
    click_button 'Gegevens kloppen'

    expect(page).to have_content('U gaat door naar de betaalomgeving.')
    expect(page).to eq basket_path(basket)
  end

  scenario 'vóór het afrekenen' do
    # in de winkelomgeving ...
    visit shop_url
    click_link 'inloggen'
    fill_in "E-mail", with: user.email
    fill_in "Wachtwoord", with: "password"
    click_button "Log in"

    expect(page).to have_content "U bent succesvol ingelogd."
    expect(page).to have_content "#{user.first_name}"
    expect(page).to have_current_path shop_path
  end

  # Nog vorm te geven:
  # scenario 'vóór het afrekenen met een gevuld mandje' do
  #   # in de winkelomgeving ...
  #   visit '/categories'
  #   click_link 'inloggen'
  #   fill_in "E-mail", with: user.email
  #   fill_in "Wachtwoord", with: "password"
  #   click_button "Log in"
  #
  #   expect(page).to have_content "U bent succesvol ingelogd."
  #   expect(page).to have_content "#{user.firstname}"
  #   expect(page).to have_current_path(categories_path)
  # end
end
