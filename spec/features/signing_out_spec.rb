require 'rails_helper'

RSpec.feature 'User kan uitloggen' do
  let!(:user) { FactoryGirl.create(:user) }

  before do
    login_as user
  end

  scenario "met succes" do
    visit "/"
    click_link "log uit"
    expect(page).to have_content "U bent succesvol uitgelogd."
  end
end