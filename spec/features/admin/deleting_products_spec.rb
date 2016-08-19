require 'rails_helper'

RSpec.feature 'Admin kan producten verwijderen', :pending do
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(:admin)
    visit products_path
  end

  scenario 'met succes' do
    page.find('li', :text => 'Honingpot 200ml').click_link 'Verwijder'

    expect(page).to have_content 'Product is verwijderd.'
    expect(page).to have_no_content 'Honingpot 200ml'
  end
end