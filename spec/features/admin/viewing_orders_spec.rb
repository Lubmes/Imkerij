require 'rails_helper'

RSpec.feature 'Admin kan orders overzien' do
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:customer) { FactoryGirl.create( :user ) }
  let!(:order_1) { FactoryGirl.create( :order, customer: customer ) }
  let!(:booking_1) { FactoryGirl.create( :booking,  product_name: 'Honingpot', 
                                                    product_quantity: 4, 
                                                    product_price: '5,00' ) }
  let!(:order_2) { FactoryGirl.create( :order, customer: customer ) }
  let!(:booking_2) { FactoryGirl.create( :booking,  product_name: 'Streekpakket',
                                                    product_quantity: 2, 
                                                    product_price: '10,00', 
                                                    order: order_2 ) }

  before do
    order_1.bookings << booking_1
    order_2.bookings << booking_2
    order_1.sum_all_bookings
    order_2.sum_all_bookings

    login_as(admin)
    login_as(customer)
    visit orders_path
  end

  scenario 'met succes' do
    # Een centrale lijst met te verzenden orders.
    within('table#paid') do
      expect(page).to have_content '5,00'
    end
  end

  xcontext 'en bij het in gebreke blijken te zijn' do
    scenario 'naleveren' do
      # Producten moeten aangevinkt worden als naleverbaar en
      # gedifferentieerd in de lijst komen te staan. 
    end

    scenario 'geld terugstorten' do
      # Niet na te leveren items, of op speciaal verzoek ongewenste items,
      # moeten terugstortbaar zijn. (Kan via third party betaalsysteem.)
    end
  end
end