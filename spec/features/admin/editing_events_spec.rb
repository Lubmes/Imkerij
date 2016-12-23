require 'rails_helper'

RSpec.feature 'Admin kan agenda bijwerken' do
  let!(:event) { FactoryGirl.create(:event, name: 'Vlindernacht',
                                            description: 'Verhalen van een vlinderexpert.',
                                            date: 14.days.from_now) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(admin)
    visit events_path
  end

  scenario 'met valide details' do
    page.find('.event', :text => 'Vlindernacht').click_link 'BIJWERKEN'
    fill_in 'Naam', with: 'Muggen- en vlindernacht'
    fill_in 'Omschrijving', with: 'Verhalen van een vlinderexpert. Muggenzalf aanwezig.'
    find('#datetimejs-input').set 21.days.from_now.beginning_of_day + 20.5.hours
    click_button 'Opslaan'

    expect(page).to have_content 'Agendapunt is bijgewerkt.'
    expect(page).to have_content 'Muggen- en vlindernacht'
    expect(page).to have_content 'Verhalen van een vlinderexpert. Muggenzalf aanwezig.'
    expect(page).to have_content I18n.l(21.days.from_now.beginning_of_day + 20.5.hours, format: :long)
    expect(page).to have_no_content 14.days.from_now
  end
end
