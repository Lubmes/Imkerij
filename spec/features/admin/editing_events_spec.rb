require 'rails_helper'

feature 'Admin kan agenda bijwerken' do
  create_navigation
  let!(:event) { create(:event, name: 'Vlindernacht',
                         description: 'Verhalen van een vlinderexpert.',
                                date: 14.days.from_now) }
  let(:admin)  { create(:user, :admin) }

  before do
    login_as(admin)
    visit events_path
  end

  scenario 'met valide details' do
    page.find('.event', :text => 'Vlindernacht').click_link 'bijwerken'
    fill_in 'Naam', with: 'Muggen- en vlindernacht'
    fill_in 'Omschrijving', with: 'Verhalen van een vlinderexpert. Muggenzalf aanwezig.'
    find('#datetimejs-input').set 21.days.from_now.beginning_of_day + 20.5.hours
    click_button 'Agendapunt bijwerken'

    expect(page).to have_content 'Agendapunt is bijgewerkt.'
    expect(page).to have_content 'Muggen- en vlindernacht'
    expect(page).to have_content 'Verhalen van een vlinderexpert. Muggenzalf aanwezig.'
    expect(page).to have_content I18n.l(21.days.from_now.beginning_of_day + 20.5.hours, format: :event_date)
    expect(page).to have_content I18n.l(21.days.from_now.beginning_of_day + 20.5.hours, format: :event_time)
    expect(page).to have_no_content 14.days.from_now
  end
end
