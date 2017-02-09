require 'rails_helper'

RSpec.feature 'Admin kan agendapunten verwijderen' do
  let!(:event) { FactoryGirl.create(:event, name: 'Vlindernacht',
                                            description: 'Verhalen van een vlinderexpert.',
                                            date: 14.days.from_now) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

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
