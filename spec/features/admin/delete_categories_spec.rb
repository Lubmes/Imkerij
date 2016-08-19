require 'rails_helper'

RSpec.feature 'Admin kan categorieën verwijderen', :pending do
  let!(:categorie) { FactoryGirl.create(:categorie, name: 'Kaarsen') }
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(:admin)
    visit products_path
  end

  scenario 'met succes' do
    page.find('div', :text => 'Kaarsen').click_link 'Verwijder'

    expect(page).to have_content 'Product is verwijderd.'
    expect(page).to have_no_content 'Kaarsen'
  end
end