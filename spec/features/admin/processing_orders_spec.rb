require 'rails_helper'

feature 'Admin kan orders overzien' do
  create_navigation
  let(:admin)      { create(:user, :admin) }
  let(:customer)   { create( :user ) }
  # totaalbedrag: € 20,00
  let!(:order_1)   { create( :order, :customer => customer ) }
  let!(:selection_1) { create( :selection,  :product_name         => 'Honingpot',
                                            :product_quantity     => 4,
                                            :product_price        => '5,00',
                                            :product_mail_weight  => '460',
                                            :product_sales_tax    => 6,
                                            :order                => order_1) }
  # totaalbedrag: € 21,00
  let!(:order_2)   { create( :order, :customer => customer ) }
  let!(:selection_2) { create( :selection,  :product_name         => 'Handoeken',
                                            :product_quantity     => 2,
                                            :product_price        =>'10,50',
                                            :product_mail_weight  => '1600',
                                            :product_sales_tax    => 21,
                                            :order                => order_2 ) }

  before do
    [order_1, order_2].each do |order|
      order.sum_all_selections
      order.status = :paid
      order.save!
    end

    login_as(admin)
    visit orders_path
  end

  scenario 'met succes' do
    # Een centrale lijst met te verzenden orders.
    within('#paid') do
      expect(page).to have_content '20,00'
      expect(page).to have_content '21,00'
    end
  end

  context 'en bij het in gebreke blijken te zijn' do
    xscenario 'naleveren' do
      # Producten moeten aangevinkt worden als naleverbaar en
      # gedifferentieerd in de lijst komen te staan.
    end

    xscenario 'geld terugstorten' do
      # Niet na te leveren items, of op speciaal verzoek ongewenste items,
      # moeten terugstortbaar zijn. (Kan via third party betaalsysteem.)
    end
  end
end
