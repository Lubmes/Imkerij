class OrdersController < ApplicationController
  include ShoppingOrder
  before_action :set_shopping_order, only: [:show, :empty, :check_out, :confirm, :pay]
  before_action :set_order, only: [:set_package_delivery, :success, :problem]
  before_action :set_user, only: [:set_package_delivery, :check_out, :confirm, :success]

  require 'mollie/api/client'
  require 'mailgun'
  require 'easypost'

  def show
  end

  def index
    all_orders = Order.all.order(updated_at: :asc)
    @open_orders = all_orders.open
    @problem_orders = all_orders.problem
    @paid_orders = all_orders.paid
    @sent_orders = all_orders.sent.order(updated_at: :desc)
  end

  def empty
    @order.selections.delete_all
    @order.sum_all_selections
    @order.save
    respond_to do |format|
      format.html { redirect_to shop_path }
      format.js { render layout: false }
    end
  end

  def check_out
    @order.at_check_out!
    @deliveries = @user.deliveries if @user
  end

  def confirm
    # Vanuit @order worden alle gegevens in de view opgebouwd.
    @customer = @order.customer
    @delivery = @order.package_delivery

    if @delivery.nil?
      flash.keep[:alert] = 'U moet een verzendadres opgeven.'
      redirect_to [:check_out, @order]
    end
    if @user == nil
      flash.now[:alert] = 'U moet eerst inloggen of aanmelden.'
      render 'check_out'
    end
    @order.confirmed!
    @order.save
  end

  def pay
    mollie = Mollie::API::Client.new ENV["mollie_api_key"]

    begin
      payment = mollie.payments.create({
                  :method      => "ideal",
                  :amount      => @order.total_price_in_euros,
                  :description => "#{@order.customer.first_name} #{@order.customer.last_name} order: #{@order.id}",
                  :redirectUrl => "#{root_url}orders/#{@order.id}/success",
                  :metadata    => {
                      :order_id => @order.id
                  }
                })
      # Store payment id to be able to retrieve payment later.
      @order.payment_id = payment.id
      @order.save
      # Sending the customer off to complete the payment....
      redirect_to payment.payment_url
    rescue Mollie::API::Exception => e
      flash.now[:alert] = 'Er ging iets mis met uw betaling.'
      redirect_to shop_path
    end
  end

  def success
    if @user == nil
      flash.now[:alert] = 'U moet eerst inloggen of aanmelden.'
      render 'check_out'
    end
    mollie = Mollie::API::Client.new ENV["mollie_api_key"]
    payment  = mollie.payments.get @order.payment_id
    if payment.paid?
      session[:order_id] = nil
      @customer = @order.customer
      @delivery = @order.package_delivery
      @order.paid!
      if @order.invoices.empty?
        @invoice = @order.invoices.create(paid: @order.total_price,
                                          total_mail_weight: @order.total_mail_weight,
                                          invoice_delivery: @delivery)

        @invoice.update_attributes(closed: true)
        # Mail factuur naar interne printer.
        mg_client = Mailgun::Client.new ENV["mailgun_api_key"]
        message_params_to_printer =  {
          :from     => 'postmaster@mg.rexcopa.nl',
          :to       => 'lmschukking@icloud.com',
          :subject  => "Printer: Invoice id: #{@invoice.id}",
          :text     => "Here should be a pdf of an invoice with amount paid: #{@invoice.paid}"
        }
        message_params_to_customer =  {
          :from     => 'postmaster@mg.rexcopa.nl',
          :to       => 'lmschukking@icloud.com',
          :subject  => "Customer: Invoice id: #{@invoice.id}",
          :text     => order_received_confirmation(@invoice)
        }
        mg_client.send_message 'mg.rexcopa.nl', message_params_to_printer
        mg_client.send_message 'mg.rexcopa.nl', message_params_to_customer
      end
      # Easypost pakketverstuur dienst.
      # EasyPost.api_key = ENV["easypost_api_key"]
      # to_address = EasyPost::Address.create(
      #   :name     => "#{@user.first_name} #{@user.last_name}",
      #   :street1  => "#{@delivery.address_street_name} #{@delivery.address_street_number}",
      #   :city     => @delivery.address_city,
      #   :zip      => @delivery.address_zip_code,
      #   :country  => @delivery.address_country
      # )
      # from_address = EasyPost::Address.create(
      #   :company  => 'Imkerij Poppendamme',
      #   :street1  => 'Poppendamseweg 3',
      #   :city     => 'Grijpskerke',
      #   :zip      => '4364SL',
      # )
      # # pakket (ounces en inches)
      # parcel = EasyPost::Parcel.create(
      #   :width  => 15.2,
      #   :length => 18,
      #   :height => 9.5,
      #   :weight => @invoice.total_mail_weight
      # )
      # @shipment = EasyPost::Shipment.create(
      #   :to_address   => to_address,
      #   :from_address => from_address,
      #   :parcel       => parcel
      # )
    else
      redirect_to [:confirm, @order]
      flash.now[:alert] = 'Uw betaling is niet geslaagd.'
    end
  end

  def problem
    @order.problem!
  end

  private

  def order_params
    params.require(:order).permit([:package_delivery_id])
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  def order_received_confirmation(invoice)
    <<~EOF
      Uw bestelling is ontvangen. Deze wordt zo spoedig mogelijk naar u opgestuurd.

      Here should be a pdf of an invoice with amount paid: #{invoice.paid}
    EOF
  end
end
