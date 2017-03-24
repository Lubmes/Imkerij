require 'rails_helper'

feature 'Admin kan agendapunten verwijderen' do
  create_navigation
  let!(:event) { create(:event, name: 'Vlindernacht',
                                            description: 'Verhalen van een vlinderexpert.',
                                            date: 14.days.from_now) }
  let(:admin)  { create(:user, :admin) }

  before do
    login_as(admin)
    visit events_path
  end

  scenario 'met succes' do
    page.find('.event', :text => 'Vlindernacht').click_link 'verwijderen'

    expect(page).to have_content 'Agendapunt is verwijderd.'
    expect(page).to have_no_content 'Vlindernacht'
  end
end
