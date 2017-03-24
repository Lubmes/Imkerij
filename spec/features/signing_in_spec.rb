require 'rails_helper'

feature 'User kan inloggen' do
  create_navigation
  let(:user) { create(:user) }

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
end
