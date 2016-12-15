require 'rails_helper'

RSpec.feature 'Admin kan nieuwe agendapunten toevoegen' do
  let(:admin) { FactoryGirl.create(:user, :admin) }

	before do
    login_as(admin)
    visit events_path
    click_link 'nieuw agendapunt'
  end

  scenario 'met valide details' do
  	fill_in 'Naam', with: 'Vlindernacht'
  	fill_in 'Omschrijving', with: 'Verhalen van een vlinderexpert.'
    fill_in 'Tijdstip', with: 14.days.from_now.beginning_of_day + 20.5.hours
  	click_button 'Opslaan'

    expect(page).to have_content 'Agendapunt is toegevoegd.'
  	expect(page).to have_content 'Vlindernacht'
  	expect(page).to have_content 'Verhalen van een vlinderexpert.'
  	expect(page).to have_content 14.days.from_now.beginning_of_day + 20.5.hours
  end

  scenario 'met invalide details' do
    fill_in 'Naam', with: ''
    fill_in 'Omschrijving', with: ''
    fill_in 'Tijdstip', with: ''
    click_button 'Opslaan'   

    expect(page).to have_content 'Agendapunt is niet toegevoegd.'
    expect(page).to have_content 'moet opgegeven zijn'
    expect(page).to have_content 'moet opgegeven zijn'
    expect(page).to have_content 'moet opgegeven zijn'
    expect(page).to have_content 'moet in de toekomst zijn' 
  end
end