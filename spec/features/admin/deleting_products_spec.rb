require 'rails_helper'

RSpec.feature 'Admin kan producten verwijderen' do
  let!(:category) { FactoryGirl.create(:category, name: 'Honing') }
  let!(:product) { FactoryGirl.create(:product,
                                          name: 'Honingpot 200ml',
                                      category: category ) }
  let(:admin) { FactoryGirl.create(:user, :admin) }

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
