require 'rails_helper'

feature 'Admin kan orders overzien', :pending do
  let(:admin)      { create(:user, :admin) }
  let(:customer)   { create( :user ) }
  let!(:order_1)   { create( :order, customer: customer ) }
  let!(:booking_1) { create( :booking,  product_name: 'Honingpot',
                                    product_quantity: 4,
                                       product_price: '5,00',
                                 product_mail_weight: '460' ) }
  let!(:order_2)   { create( :order, customer: customer ) }
  let!(:booking_2) { create( :booking,  product_name: 'Streekpakket',
                                    product_quantity: 2,
                                       product_price: '10,00',
                                 product_mail_weight: '1600',
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
