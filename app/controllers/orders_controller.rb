class OrdersController < ApplicationController
  include ShoppingOrder
  before_action :set_shopping_order, only: [:show, :empty, :check_out, :confirm, :pay]
  before_action :set_order, only: [:set_package_delivery, :success, :problem]
  before_action :set_user, only: [:set_package_delivery, :check_out, :confirm, :success]

  require 'mollie/api/client'
  require 'mailgun'
  require 'easypost'
  require 'savon'

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
    if @user
      @deliveries = @user.deliveries
      if @deliveries.any? && @order.package_delivery.nil?
        @order.package_delivery = @user.orders.where.not(payment_id: nil).last.package_delivery
      end
    end
    @order.save!
  end

  def confirm
    # Vanuit @order worden alle gegevens in de view opgebouwd.
    @customer = @order.customer
    @delivery = @order.package_delivery

    if @user == nil
      flash.keep[:alert] = 'U moet uzelf eerst inloggen of aanmelden.'
      redirect_to [:check_out, @order]
    elsif @delivery.nil?
      flash.keep[:alert] = 'U moet uw verzendadres doorgeven.'
      redirect_to [:check_out, @order]
    else
      @order.confirmed!
      @order.save
    end
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
        message_params_to_printer = {
          :from     => 'postmaster@mg.rexcopa.nl',
          :to       => 'lmschukking@icloud.com',
          :subject  => @invoice.storewide_identification_number,
          :html     => (render_to_string('../views/invoices/printer_mail', layout: 'invoice_pdf.html')).to_str
        }

        message_params_to_customer = {
          :from     => 'postmaster@mg.rexcopa.nl',
          :to       => 'lmschukking@icloud.com',
          :subject  => "Customer: Invoice id: #{@invoice.id}",
          :text     => order_received_confirmation(@invoice)
        }
        mg_client.send_message 'mg.rexcopa.nl', message_params_to_printer
        mg_client.send_message 'mg.rexcopa.nl', message_params_to_customer
      else
        @invoice = @order.active_invoice
      end
      # Initiatie verzendproces
      # soap_header = {
      #                 "Action" =>  "http://postnl.nl/cif/services/BarcodeWebService/IBarcodeWebService/GenerateBarcode",
      #                 "Security" => {
      #                   "UsernameToken" => {
      #                     "Username" => 'devc_!R4xc8p9',
      #                     "Password" => ''
      #                   }
      #                 },
      #                 :attributes! => {
      #                   "Envelope" => {
      #                     "xmlns:s" => "http://schemas.xmlsoap.org/soap/envelope/"
      #                   },
      #                   "Action" => {
      #                     "s:mustUnderstand" => "1",
      #                     "xmlns" => "http://schemas.microsoft.com/ws/2005/05/addressing/none"
      #                   },
      #                   "Security" => {
      #                     "xmlns" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"
      #                   }
      #                 }
      #               }
      #
      # message = {
      #               "d6p1:Customer" => {
      #                 "d6p1:CustomerCode"    => 'DEVC',
      #                 "d6p1:CustomerNumber"  => 11223344
      #               },
      #               "d6p1:Barcode" => {
      #                 "d6p1:Type" => '3S',
      #                 "d6p1:Range" => 'DEVC',
      #                 "d6p1:Serie" => '1000000-2000000'
      #               },
      #               :attributes! => {
      #                 "wsdl:GenerateBarcode" => {
      #                   "xmlns:d6p1" => "http://postnl.nl/cif/domain/BarcodeWebService/",
      #                   "xmlns:i" => "http://www.w3.org/2001/XMLSchema-instance",
      #                   "xmlns" => "http://postnl.nl/cif/services/BarcodeWebService/"
      #                 }
      #               }
      #           }
      #
      # @client = Savon.client(
      #   :soap_header => soap_header,
      #   # :namespace_identifier => :none,
      #   :env_namespace => :s,
      #   :convert_request_keys_to => :camelcase,
      #   :raise_errors => false,
      #   :pretty_print_xml => true,
      #   :endpoint => 'https://testservice.postnl.com/CIF_SB/BarcodeWebService/1_1/BarcodeWebService.svc',
      #   :wsdl => 'https://testservice.postnl.com/CIF_SB/BarcodeWebService/1_1/?wsdl')
      #
      # @request = @client.build_request(:generate_barcode) do
      #   message message
      end

      @response = @client.call(:generate_barcode) do
        message message
      end
    else
      redirect_to [:confirm, @order]
      flash.now[:alert] = 'Uw betaling is niet geslaagd.'
    end
    # InvoiceMailer.paid_notification(@order.invoices.last, @user).deliver_now
    # mg_client = Mailgun::Client.new ENV["mailgun_api_key"]
    # message_params_to_printer = {
    #   :from     => 'postmaster@mg.rexcopa.nl',
    #   :to       => 'lmschukking@icloud.com',
    #   :subject  => "Printer: Invoice id: #{@invoice.storewide_identification_number}",
    #   :html     => (render_to_string(
    #                   '../views/invoices/printer_mail')).to_str
    # }
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
