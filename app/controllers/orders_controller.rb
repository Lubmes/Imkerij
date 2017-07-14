class OrdersController < ApplicationController
  include ShoppingOrder
  before_action :set_shopping_order, only: [:show, :empty, :check_out, :confirm, :pay]
  before_action :set_order, only: [:set_package_delivery, :success, :problem]
  before_action :set_user, only: [:set_package_delivery, :check_out, :confirm, :success]

  require 'mollie/api/client'
  require 'mailgun'
  require 'savon'

  def show
  end

  def index
    if params[:year_start].blank?

    else
      case params[:quarter_start]
      when "I"
        m_s = 1
        d_s = 1
      when "II"
        m_s = 4
        d_s = 1
      when "III"
        m_s = 7
        d_s = 1
      when "IV"
        m_s = 10
        d_s = 1
      else
        m_s = 1
        d_s = 1
      end
      case params[:quarter_end]
      when "I"
        m_e = 3
        d_e = 31
      when "II"
        m_e = 6
        d_e = 30
      when "III"
        m_e = 9
        d_e = 30
      when "IV"
        m_e = 12
        d_e = 31
      else
        m_e = 12
        d_e = 31
      end
      @start_time = DateTime.civil(params[:year_start].to_i, m_s, d_s).beginning_of_day.in_time_zone
      @end_time   = DateTime.civil(params[:year_end].to_i, m_e, d_e).end_of_day.in_time_zone

      ####
      # @invoices = Invoice.filter(@start_time)
      @invoices = Invoice.where('updated_at > ?', @start_time).where('updated_at < ?', @end_time)
      @turnover_6 = 0
      @turnover_21 = 0

      @invoices.each do |invoice|
        # Selections
        if invoice.sequence_number == 1
          invoice.order.selections.each do |selection|
            q = selection.product_quantity
            p = selection.product_price
            if selection.product_sales_tax == 6.0
              @turnover_6 += q * p
            else selection.product_sales_tax == 21.0
              @turnover_21 += q * p
            end
          end
        # Corrections
        else
          invoice.corrections.each do |correction|
            q = correction.quantity
            p = correction.selection.product_price
            if correction.selection.product_sales_tax == 6.0
              @turnover_6 += q * p
            else correction.selection.product_sales_tax == 21.0
              @turnover_21 += q * p
            end
          end
        end
      end
      # Belasting-resultaat invioce
      @turnover_tax_6 = @turnover_6 * 0.06
      @turnover_tax_21 = @turnover_21 * 0.21
    end

    ### Zoals het was.
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
      #                     "Username" => ENV['postnl_username'],
      #                     "Password" => ENV['postnl_password']
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
      #                   },
      #                   "GenerateBarcode" => {
      #                     "xmlns:d6p1" => "http://postnl.nl/cif/domain/BarcodeWebService/",
      #                     "xmlns:i" => "http://www.w3.org/2001/XMLSchema-instance",
      #                     "xmlns" => "http://postnl.nl/cif/services/BarcodeWebService/"
      #                     }
      #                 }
      #               }
      #
      # message = {
      #             "d6p1:Customer" => {
      #               "d6p1:CustomerCode"    => 'DEVC',
      #               "d6p1:CustomerNumber"  => 11223344
      #             },
      #             "d6p1:Barcode" => {
      #               "d6p1:Type" => '3S',
      #               "d6p1:Range" => 'DEVC',
      #               "d6p1:Serie" => '1000000-2000000'
      #             },
      #             # :attributes! => {
      #             #
      #             #   }
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
      # end

      # XML direct gemanipuleerd.
#       @client = Savon.client(
#         :endpoint => 'https://testservice.postnl.com/CIF_SB/BarcodeWebService/1_1/BarcodeWebService.svc',
#         :wsdl => 'https://testservice.postnl.com/CIF_SB/BarcodeWebService/1_1/?wsdl')
#
#       @request = @client.build_request(:generate_barcode,
#         xml: %Q{<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
#   <s:Header>
#     <Action s:mustUnderstand="1" xmlns="http://schemas.microsoft.com/ws/2005/05/addressing/none">http://postnl.nl/cif/services/BarcodeWebService/IBarcodeWebService/GenerateBarcode</Action>
#     <Security xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
#       <wsse:UsernameToken xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
#         <wsse:Username>devc_!R4xc8p9</wsse:Username>
#         <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">098fd559930983af31ef6630a0bb0c1974156561</wsse:Password>
#       </wsse:UsernameToken>
#     </Security>
#   </s:Header>
#   <s:Body>
#     <GenerateBarcode xmlns:d6p1="http://postnl.nl/cif/domain/BarcodeWebService/" xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://postnl.nl/cif/services/BarcodeWebService/">
#       <d6p1:Message>
#         <d6p1:MessageID>5</d6p1:MessageID>
#         <d6p1:MessageTimeStamp>#{l Time.now, format: :postnl_api}</d6p1:MessageTimeStamp>
#       </d6p1:Message>
#       <d6p1:Customer>
#         <d6p1:CustomerCode>DEVC</d6p1:CustomerCode>
#         <d6p1:CustomerNumber>11223344</d6p1:CustomerNumber>
#       </d6p1:Customer>
#       <d6p1:Barcode>
#         <d6p1:Type>3S</d6p1:Type>
#         <d6p1:Range>DEVC</d6p1:Range>
#         <d6p1:Serie>100000000-200000000</d6p1:Serie>
#       </d6p1:Barcode>
#     </GenerateBarcode>
#   </s:Body>
# </s:Envelope>})

# @response = @client.call(:generate_barcode,
#   xml: %Q{<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
# <s:Header>
# <Action s:mustUnderstand="1" xmlns="http://schemas.microsoft.com/ws/2005/05/addressing/none">http://postnl.nl/cif/services/BarcodeWebService/IBarcodeWebService/GenerateBarcode</Action>
# <Security xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
# <wsse:UsernameToken xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
#   <wsse:Username>devc_!R4xc8p9</wsse:Username>
#   <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">098fd559930983af31ef6630a0bb0c1974156561</wsse:Password>
# </wsse:UsernameToken>
# </Security>
# </s:Header>
# <s:Body>
# <GenerateBarcode xmlns:d6p1="http://postnl.nl/cif/domain/BarcodeWebService/" xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://postnl.nl/cif/services/BarcodeWebService/">
# <d6p1:Message>
#   <d6p1:MessageID>5</d6p1:MessageID>
#   <d6p1:MessageTimeStamp>#{l Time.now, format: :postnl_api}</d6p1:MessageTimeStamp>
# </d6p1:Message>
# <d6p1:Customer>
#   <d6p1:CustomerCode>DEVC</d6p1:CustomerCode>
#   <d6p1:CustomerNumber>11223344</d6p1:CustomerNumber>
# </d6p1:Customer>
# <d6p1:Barcode>
#   <d6p1:Type>3S</d6p1:Type>
#   <d6p1:Range>DEVC</d6p1:Range>
#   <d6p1:Serie>100000000-200000000</d6p1:Serie>
# </d6p1:Barcode>
# </GenerateBarcode>
# </s:Body>
# </s:Envelope>})


    else
      flash.now[:alert] = 'Uw betaling is niet geslaagd.'
      redirect_to [:confirm, @order]
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
    authorize @order
    @order.problem!
  end

  def filter

  end

  private

  def order_params
    params.require(:order).permit([:package_delivery_id, :sales_tax, :year_start, :year_end, :quarter_start, :quarter_end])
  end

  def sorting_params(params)
    params.slice(:sales_tax, :year_start, :year_end, :quarter_start, :quarter_end)
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
