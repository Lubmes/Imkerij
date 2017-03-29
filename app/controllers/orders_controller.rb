class OrdersController < ApplicationController
  include ShoppingOrder
  before_action :set_shopping_order, only: [:show, :empty, :check_out, :confirm, :pay]
  before_action :set_order, only: [:success]
  before_action :set_user, only: [:check_out, :confirm, :success]

  require 'mollie/api/client'

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
    @order.bookings.delete_all
    @order.sum_all_bookings
    @order.save
    respond_to do |format|
      format.html { redirect_to shop_path }
      format.js { render layout: false }
    end
  end

  def check_out
    @order.open! if @order.confirmed?
    # gebruiker selecteerd een adres uit zijn bestand.
    @delivery = @user.deliveries.first unless @user.nil?
    if @delivery
      @order.package_delivery = @delivery
      @order.save
    end
  end

  def confirm
    # Vanuit @order worden alle gegevens in de view opgebouwd.
    @customer = @order.customer
    @delivery = @order.package_delivery

    if @delivery.nil?
      flash.now[:alert] = 'U moet een verzendadres opgeven.'
      render 'check_out'
    end
    if @user == nil
      flash.now[:alert] = 'U moet eerst inloggen of aanmelden.'
      render 'check_out'
    end
    @order.confirmed!
    @order.save
  end

  def pay
    mollie = Mollie::API::Client.new 'test_EygcTKUUPHnS85C4c5x2GAQ74rnyWr'

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
      $response.body << "API call failed: " << (CGI.escapeHTML e.message)
    end
  end

  def success
    mollie = Mollie::API::Client.new 'test_EygcTKUUPHnS85C4c5x2GAQ74rnyWr'
    payment  = mollie.payments.get @order.payment_id
    if payment.paid?
      session[:order_id] = nil
      if @user == nil
        flash.now[:alert] = 'U moet eerst inloggen of aanmelden.'
        render 'check_out'
      end
      @customer = @order.customer
      @delivery = @order.package_delivery
      @order.paid!
      @invoice = @order.invoices.create(paid: @order.total_price,
                                        total_mail_weight: @order.total_mail_weight,
                                        invoice_delivery: @order.package_delivery)

      internal_print_mail = InvoiceMailer.internal_print_email(@invoice)
      # internal_print_mail.attachment(order_invoice_download_path(@order, @invoice, format: "pdf"))
      internal_print_mail.deliver
    else
      redirect_to [:confirm, @order]
      flash.now[:alert] = 'Uw betaling is niet geslaagd.'
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_user
    @user = current_user
  end
end
