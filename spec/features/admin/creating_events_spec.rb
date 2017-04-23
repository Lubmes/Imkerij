require 'rails_helper'

feature 'Admin kan nieuwe agendapunten toevoegen' do
  create_navigation
  let(:admin) { create(:user, :admin) }
  let(:picture) { FactoryGirl.build_stubbed :picture }

	before do
    login_as(admin)
    visit events_path
    click_link 'nieuw agendapunt'
  end

  xscenario 'met valide details' do

  	fill_in 'Naam', with: 'Vlindernacht'
    attach_file('image', File.absolute_path('./spec/test_files/huis.jpg'))
  	fill_in 'Omschrijving', with: 'Verhalen van een vlinderexpert.'
    find('#datetimejs-input').set 14.days.from_now.beginning_of_day + 20.5.hours
  	click_button 'Agendapunt toevoegen'

    expect(page).to have_content 'Agendapunt is toegevoegd.'
  	expect(page).to have_content 'Vlindernacht'
  	expect(page).to have_content 'Verhalen van een vlinderexpert.'
  	expect(page).to have_content I18n.l(14.days.from_now.beginning_of_day + 20.5.hours, format: :event_date)
    expect(page).to have_content I18n.l(14.days.from_now.beginning_of_day + 20.5.hours, format: :event_time)
  end

  scenario 'met invalide details' do
    fill_in 'Naam', with: ''
    fill_in 'Omschrijving', with: ''
    find('#datetimejs-input').set ''
    click_button 'Agendapunt toevoegen'

    expect(page).to have_content 'Agendapunt is niet toegevoegd.'
    expect(page).to have_content 'moet opgegeven zijn'
    expect(page).to have_content 'moet opgegeven zijn'
    expect(page).to have_content 'moet opgegeven zijn'
    expect(page).to have_content 'moet in de toekomst zijn'
  end
end
