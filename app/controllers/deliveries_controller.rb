class DeliveriesController < ApplicationController
  def create
    @delivery = Delivery.new(delivery_params)
    # authorize @delivery

    @customer = @delivery.sender
    @order = @customer.orders.open.last
    @deliveries = @customer.deliveries

    @order.package_delivery = @delivery
    @order.save
    if @delivery.save
      # flash[:notice] = 'Adres is toegevoegd.'
      # ^ is storend in betaalproces.
    else
      flash.now[:alert] = 'Adres is niet toegevoegd.'
    end
  end

  def edit
    @delivery = Delivery.find(params[:id])
  end

  def update
    @delivery = Delivery.find(params[:id])
    # authorize @delivery


    @customer = @delivery.sender
    @order = @customer.orders.open.last
    @deliveries = @customer.deliveries

    if @delivery.update(delivery_params)
      flash[:notice] = "Adres is bijgewerkt."
    else
      flash.now[:alert] = "Adres is niet bijgewerkt."
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
      :address_zip_code, :address_city, :address_country, :sender_id )
  end
end
