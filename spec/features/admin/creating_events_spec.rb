require 'rails_helper'

RSpec.feature 'Admin kan nieuwe agendapunten toevoegen', :pending do
  let(:user) { FactoryGirl.create(:user, :admin) }

	before do
    login_as(:admin)
    visit agenda_path
    click_link 'Nieuw agendapunt'
  end

  scenario 'met valide details' do
  	fill_in 'Titel', with: 'Vlindernacht'
  	fill_in 'Omschrijving', with: 'Verhalen van een vlinderexpert.'
  	fill_in 'Datum en tijd', with: 14.days.from_now # op 20:30
  	click_link 'Agendapunt toevoegen'

  	expect(page).to have_content 'Vlindernacht'
  	expect(page).to have_content 'Verhalen van een vlinderexpert.'
  	expect(page).to have_content 14.days.from_now # op 20:30
  end
end