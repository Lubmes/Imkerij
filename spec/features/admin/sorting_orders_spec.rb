require 'rails_helper'

feature 'Admin kan gesorteerde orders inzien en vult in:' do
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
  # totaalbedrag: € 22,00
  let!(:order_2)   { create( :order, :customer => customer ) }
  let!(:selection_2) { create( :selection,  :product_name         => 'Handoeken',
                                            :product_quantity     => 2,
                                            :product_price        =>'10,50',
                                            :product_mail_weight  => '1600',
                                            :product_sales_tax    => 21,
                                            :order                => order_2 ) }
  # totaalbedrag: € 32,00
  let!(:order_3)   { create( :order, :customer => customer ) }
  let!(:selection_3) { create( :selection,  :product_name         => 'Streekpakket',
                                            :product_quantity     => 2,
                                            :product_price        =>'18,00',
                                            :product_mail_weight  => '1600',
                                            :product_sales_tax    => 6,
                                            :order                => order_3 ) }

  before do
    order_1.created_at = 30.days.ago
    order_2.created_at = 30.days.ago
    order_3.created_at = 6.days.ago

    [order_1, order_2, order_3].each do |order|
      order.sum_all_selections
      order.status = :paid
      order.save!
    end

    login_as(admin)
    visit orders_path
  end

  scenario 'niets' do
    within('#paid') do
      expect(page).to have_content '20,00'
    end
  end

  scenario 'een begindatum en een einddatum' do
    # find('#datetimejs-input-start').set 31.days.ago
    # find('#datetimejs-input-end').set 7.days.ago
    # (select from)
    # select_from 'BTW-tarief', with: 6

    # Een centrale lijst met te verzenden orders.
    within('#paid') do
      expect(page).to have_content '20,00'
    end
  end

end
