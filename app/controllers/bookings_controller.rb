class BookingsController < ApplicationController
  include ShoppingOrder
  # Om AJAX op de boekingen te laten werken.
  skip_before_action :verify_authenticity_token, :only => [:create]
  # before_action :set_order, only: [:create, :update, :destroy]
  before_action :set_shopping_order, only: [:create, :update, :destroy]
  before_action :set_booking, only: [:update, :destroy]
  # (Geen after_action update_order. Werkt niet met AJAX.)

  def create
    product = Product.find(params[:booking][:product_id])
    booking = @order.bookings.find_by(product_id: product.id)
    unless booking
      booking = Booking.new(booking_params)
      booking.product_name  = product.name
      booking.product_price = product.price
      booking.product_sales_tax = product.sales_tax
      booking.product_mail_weight = product.mail_weight
      @order.bookings << booking
    else
      booking.product_quantity = params[:booking][:product_quantity]
    end
    authorize booking
    booking.save
    update_order

    respond_to do |format|
      format.html { redirect_to shop_url }
      format.js
    end
  end

  def update
    # authorize @booking
    @booking.product_quantity = params[:booking][:product_quantity]
    @booking.save
    update_order

    respond_to do |format|
      format.html { redirect_to shop_url }
      format.js
    end
  end

  def destroy
    @booking.destroy
    @bookings = @order.bookings
    update_order

    respond_to do |format|
      format.html { redirect_to shop_url }
      format.js
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:product_quantity, :product_id)
  end

  # def set_shopping_order
  #   set_shopping_order
  #   # @order = current_order
  # end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def update_order
    @order.sum_all_bookings
    @order.save
  end
end
