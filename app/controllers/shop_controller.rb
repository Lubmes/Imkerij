class ShopController < ApplicationController
  def index
    skip_authorization # relevant?
    @categories = Category.all.order(id: :asc)
    # Voor het inzien van wat al geselecteerd is.
    @order = current_order
    # Voor het aanslaan van een nieuwe booking.
    @booking = current_order.bookings.build
  end
end
