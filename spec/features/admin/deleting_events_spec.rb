require 'rails_helper'

RSpec.feature 'Admin kan agendapunten verwijderen', :pending do
  let!(:event) { FactoryGirl.create(:event, title: 'Vlindernacht', 
                                            description: 'Verhalen van een vlinderexpert.', 
                                            at: 14.days.from_now) }
  let(:user) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(:admin)
    visit events_path
  end

  scenario 'met succes' do
    page.find('li', :text => 'Vlindernacht').click_link 'Verwijderen'

    expect(page).to have_content 'Agendapunt is verwijderd.'
    expect(page).to have_no_content 'Vlindernacht'
  end
end