require 'rails_helper'

feature 'Admin kan producten verwijderen' do
  create_navigation
  let!(:category) { create(:category, name: 'Honing') }
  let!(:product)  { create(:product, name: 'Honingpot 200ml',
                                 category: category ) }
  let(:admin)     { create(:user, :admin) }

  before do
    login_as(admin)
    visit shop_path
  end

  scenario 'met succes' do
    page.find('.product', :text => 'Honingpot 200ml').click_link 'verwijderen'

    expect(page).to have_content 'Product is verwijderd.'
    expect(page).to have_no_content 'Honingpot 200ml'
  end
end
