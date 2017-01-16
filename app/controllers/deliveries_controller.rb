class DeliveriesController < ApplicationController
  def create
    @delivery = Delivery.new(delivery_params)
    authorize @delivery

    # @order = Order.find(params[:id])
    if @delivery.save
      flash[:notice] = 'Adres is toegevoegd.'
      # redirect_to [:check_out, @order] # wijzig na js.
      render 'orders/check_out'
    else
      flash.now[:alert] = 'Adres is niet toegevoegd.'
      render 'orders/check_out'
    end
  end

  def destroy
    @delivery = Delivery.find(params[:id])
    authorize @delivery
    @delivery.destroy!
    flash[:notice] = 'Adres is verwijderd.'

    @order = current_order # verwijder na js
    redirect_to [:check_out, @order]
  end

  private

  def delivery_params
    params.require(:delivery).permit(:address_street_name, :address_street_number,
      :address_zip_code, :address_city, :address_country, :sender_id)
  end
end
