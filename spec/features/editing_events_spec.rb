require 'rails_helper'

RSpec.feature 'Admin kan agenda bijwerken', :pending do
  let!(:event) { FactoryGirl.create(:event, title: 'Vlindernacht',
                                            description: 'Verhalen van een vlinderexpert.',
                                            at: 14.days.from_now) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(:admin)
    visit events_path
  end

  scenario 'met valide details' do
    page.find('li', :text => 'Vlindernacht').click_link 'Bijwerken'
    fill_in 'Titel', with: 'Muggen- en vlindernacht'
    fill_in 'Omschrijving', with: 'Verhalen van een vlinderexpert. Muggenzalf aanwezig.'
    fill_in 'Tijd', with: 21.days.from_now

    expect(page).to have_content 'Agenda is bijgewerkt.'
    expect(page).to have_content 'Muggen- en vlindernacht'
    expect(page).to have_content 'Verhalen van een vlinderexpert. Muggenzalf aanwezig.'
    expect(page).to have_content 21.days.from_now
    expect(page).to have_no_content 14.days.from_now
  end
end