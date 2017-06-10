class ShopController < ApplicationController
  include ShoppingOrder

  def index
    set_shopping_order
    @order.open!
    @categories = Category.all.order(position: :asc)
    @selection = @order.selections.build
  end
end
