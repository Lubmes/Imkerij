require 'rails_helper'

feature 'User kan uitloggen' do
  create_navigation
  let!(:user) { create(:user) }

  before do
    login_as user
  end

  scenario "met succes" do
    visit shop_url
    click_link "log uit"
    expect(page).to have_content "U bent succesvol uitgelogd."
  end
end
