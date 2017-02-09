require 'rails_helper'

RSpec.feature 'Admin kan categorieën verwijderen' do
  let!(:category) { FactoryGirl.create(:category, name: 'Kaarsen') }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(admin)
    visit shop_path
  end

  scenario 'met succes' do
    page.find('.category', :text => 'Kaarsen').click_link 'verwijderen'

    expect(page).to have_content 'Categorie is verwijderd.'
    expect(page).to have_no_content 'Kaarsen'
  end
end
