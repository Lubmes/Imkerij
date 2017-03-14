class ShopController < ApplicationController
  include ShoppingOrder

  def index
    set_shopping_order
    @order.open! if @order.confirmed?
    @categories = Category.all.order(position: :asc)
    @booking = @order.bookings.build
  end
end
