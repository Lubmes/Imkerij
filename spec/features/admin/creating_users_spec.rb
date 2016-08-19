require 'rails_helper'

RSpec.feature 'Admins kan nieuwe gebruikers toevoegen', :pending do
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(admin)
    visit '/'
    click_link 'Admin'
    click_link 'Gebruikers'
    click_link 'Nieuwe Gebruiker'
  end

  scenario 'met valide details' do
    fill_in 'E-mail', with: 'newbie@example.com'
    fill_in 'Wachtwoord', with: 'password'
    click_button 'Gebruiker toevoegen'
    expect(page).to have_content 'Gebruiker is toegevoegd.'
  end

  scenario 'als de nieuwe gebruiker een admin is' do
    fill_in 'E-mail', with: 'admin@example.com'
    fill_in 'Wachtwoord', with: 'password'
    check 'Adminrechten?'
    click_button 'Gebruiker toevoegen'
    expect(page).to have_content 'Gebruiker is toevoegd.'
    expect(page).to have_content 'admin@example.com (Admin)'
  end
end