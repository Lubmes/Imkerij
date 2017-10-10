class OrdersController < ApplicationController
  include ShoppingOrder
  before_action :set_shopping_order, only: [:show, :empty, :check_out, :confirm, :pay]
  before_action :set_order, only: [:set_package_delivery, :success, :problem]
  before_action :set_user, only: [:set_package_delivery, :check_out, :confirm, :success]

  require 'mollie/api/client'
  require 'mailgun'
  require 'mini_magick'
  require 'tempfile'

  def show
  end

  def index
    authorize :order

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
      # Belasting-resultaat invoices.
      @turnover_tax_6 = @turnover_6 * 0.06
      @turnover_tax_21 = @turnover_21 * 0.21
      # Gefilterde collectie orders.
      @orders = Order.includes(:invoices).where(invoices: { id: @invoices }).order(updated_at: :asc)
    end

    ### Zoals het was.
    all_orders = @orders ? @orders : Order.all.order(updated_at: :asc)
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
    # 1. Controleer of de gebruiker überhaupt ingelogd is.
    if @user == nil
      flash.now[:alert] = 'U moet eerst inloggen of aanmelden.'
      render 'check_out'
    end
    # 2. Haal de aan de order gekoppelde payment op bij Mollie.
    mollie = Mollie::API::Client.new ENV["mollie_api_key"]
    payment  = mollie.payments.get @order.payment_id
    # 3. Controleer de payment op het slagen van de betaling.
    if payment.paid?
      # 4a. Betaling geslaagd? Dan kunnen alle gegevens compleet gemaakt worden.
      session[:order_id] = nil
      @customer = @order.customer
      @delivery = @order.package_delivery
      @order.paid!
      # 5a. En een nieuwe invoice worden gemaakt in het geval deze nog niet bestond.
      if @order.invoices.empty?
        @invoice = @order.invoices.create(paid: @order.total_price,
                                          total_mail_weight: @order.total_mail_weight,
                                          invoice_delivery: @delivery)
        @invoice.update_attributes(closed: true)

        # Mail naar interne printer.
        mg_client = Mailgun::Client.new ENV["mailgun_api_key"]
        message_params_to_printer = {
          :from     => 'postmaster@mg.rexcopa.nl',
          :to       => 'lmschukking@icloud.com',
          :subject  => @invoice.storewide_identification_number,
          :html     => (render_to_string('../views/invoices/printer_mail', layout: 'invoice_pdf.html')).to_str
        }
        # Mail naar klant
        message_params_to_customer = {
          :from     => 'postmaster@mg.rexcopa.nl',
          :to       => 'lmschukking@icloud.com',
          :subject  => "Bedankt voor uw bestelling! [#{@invoice.storewide_identification_number}]",
          :text     => order_received_confirmation_to_customer(@invoice)
        }
        mg_client.send_message 'mg.rexcopa.nl', message_params_to_printer
        mg_client.send_message 'mg.rexcopa.nl', message_params_to_customer
      else
        # 5b. Invoice bestaat wel.
        @invoice = @order.active_invoice
      end
      @run = Run.find_by(invoice_id: @invoice.id)
      unless @run
        @run = @invoice.runs.build( delivery: @delivery )
        # (6.) Een PostNL SOAP-call wordt gemaakt.
        @client_barcode = Savon.client(
          :wsdl                    => 'https://testservice.postnl.com/CIF_SB/BarcodeWebService/1_1/?wsdl',
          :log                     => true,
          :pretty_print_xml        => true
        )

        @response_barcode = @client_barcode.call( :generate_barcode, xml: %Q{
          <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:bar="http://postnl.nl/cif/services/BarcodeWebService/" xmlns:tpp="http://postnl.nl/cif/domain/BarcodeWebService/">
            <soapenv:Header>
              <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
                <wsse:UsernameToken>
                  <wsse:Username>devc_!R4xc8p9</wsse:Username>
                  <wsse:Password>#{ENV['postnl_password']}</wsse:Password>
                </wsse:UsernameToken>
              </wsse:Security>
            </soapenv:Header>
            <soapenv:Body>
              <bar:GenerateBarcode>
                <tpp:Message>
                  <tpp:MessageID>1</tpp:MessageID>
                  <tpp:MessageTimeStamp>02-05-2014 12:00:00</tpp:MessageTimeStamp>
                </tpp:Message>
                <tpp:Customer>
                  <tpp:CustomerCode>DEVC</tpp:CustomerCode>
                  <tpp:CustomerNumber>11223344</tpp:CustomerNumber>
                </tpp:Customer>
                <tpp:Barcode>
                  <tpp:Type>3S</tpp:Type>
                  <tpp:Range>DEVC</tpp:Range>
                  <tpp:Serie>000000000-999999999</tpp:Serie>
                </tpp:Barcode>
              </bar:GenerateBarcode>
            </soapenv:Body>
          </soapenv:Envelope>} ).to_hash

        @run.barcode = @response_barcode[:generate_barcode_response][:barcode]
        @run.save
      end # tijdelijk todat label ook werkt
        # 7. Label ophalen.
        @client_label = Savon.client(
          :wsdl                    => 'https://testservice.postnl.com/CIF_SB/LabellingWebService/2_1/?wsdl',
          :log                     => true,
          :pretty_print_xml        => true
        )

        @response_label = @client_label.call( :generate_label, xml: %Q{
          <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                            xmlns:lab="http://postnl.nl/cif/services/LabellingWebService/"
                            xmlns:tpp="http://postnl.nl/cif/domain/LabellingWebService/">
            <soapenv:Header>
              <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
                <wsse:UsernameToken>
                  <wsse:Username>devc_!R4xc8p9</wsse:Username>
                  <wsse:Password>#{ENV['postnl_password']}</wsse:Password>
                </wsse:UsernameToken>
              </wsse:Security>
            </soapenv:Header>
            <soapenv:Body>
              <lab:GenerateLabel>
                <tpp:Customer>
                  <tpp:Address>
                    <tpp:AddressType>02</tpp:AddressType>
                    <tpp:City>#{ENV['business_city']}</tpp:City>
                    <tpp:CompanyName>PostNL</tpp:CompanyName>
                    <tpp:Countrycode>NL</tpp:Countrycode>
                    <tpp:FirstName></tpp:FirstName>
                    <tpp:HouseNr>#{ENV['business_street_number']}</tpp:HouseNr>
                    <tpp:HouseNrExt></tpp:HouseNrExt>
                    <tpp:Name>#{ENV['business_name']}</tpp:Name>
                    <tpp:Street>#{ENV['business_street_name']}</tpp:Street>
                    <tpp:Zipcode>#{ENV['business_zipcode']}</tpp:Zipcode>
                  </tpp:Address>
                  <tpp:CollectionLocation>123456</tpp:CollectionLocation>
                  <tpp:CustomerCode>DEVC</tpp:CustomerCode>
                  <tpp:CustomerNumber>11223344</tpp:CustomerNumber>
                </tpp:Customer>
                <tpp:Message>
                  <tpp:MessageID>1</tpp:MessageID>
                  <tpp:MessageTimeStamp>29-06-2016 12:00:00</tpp:MessageTimeStamp>
                  <tpp:Printertype>GraphicFile|PDF</tpp:Printertype>
                </tpp:Message>
                <tpp:Shipments>
                  <tpp:Shipment>
                    <tpp:Addresses>
                      <tpp:Address>
                         <tpp:AddressType>01</tpp:AddressType>
                         <tpp:City>Utrecht</tpp:City>
                         <tpp:CompanyName>PostNL</tpp:CompanyName>
                         <tpp:Countrycode>NL</tpp:Countrycode>
                         <tpp:FirstName>Peter</tpp:FirstName>
                         <tpp:HouseNr>137</tpp:HouseNr>
                         <tpp:HouseNrExt/>
                         <tpp:Name>de Ruiter</tpp:Name>
                         <tpp:Street>Oldenburgerstraat</tpp:Street>
                         <tpp:Zipcode>3573SJ</tpp:Zipcode>
                      </tpp:Address>
                    </tpp:Addresses>
                    <tpp:Barcode>#{@run.barcode}</tpp:Barcode>
                    <tpp:Contacts>
                      <tpp:Contact>
                         <tpp:ContactType>01</tpp:ContactType>
                         <tpp:Email>receiver@gmail.com</tpp:Email>
                         <tpp:SMSNr>0612345678</tpp:SMSNr>
                      </tpp:Contact>
                    </tpp:Contacts>
                    <tpp:Dimension>
                      <tpp:Weight>4300</tpp:Weight>
                    </tpp:Dimension>
                    <tpp:ProductCodeDelivery>3085</tpp:ProductCodeDelivery>
                  </tpp:Shipment>
                </tpp:Shipments>
              </lab:GenerateLabel>
            </soapenv:Body>
          </soapenv:Envelope>} ).to_hash

      base_64_binary_data = @response_label[:generate_label_response][:response_shipments][:response_shipment][:labels][:label][:content]

      @pdf_file = File.open('label.pdf', 'wb') do |file|
        content = Base64.decode64 base_64_binary_data
        file << content
      end

      

      # @pdf = MiniMagick::Image.new(@pdf_file.path)
      # @pdf.pages.first.write("label.png")

      # @pdf.format "png"
      # @pdf.write "tmp/labeling/output.png"
      # pdf.pages.first.write("preview.png")


      # @label = MiniMagick::Image.new(jpg_file.path)
      # image.format "png"

      # @png = pdf.pages.first.write("preview.png")

      # @image = send_data( @png.body.string,
      #                     type: @png.content_type || 'image/png',
      #                     disposition: 'inline' )
    else
      # 4b. Betaling niet geslaagd? Dan terug naar het scherm voor het naar de bank gaan.
      flash.now[:alert] = 'Uw betaling is niet geslaagd.'
      redirect_to [:confirm, @order]
    end
  end

#   @client = Savon.client(
#              :wsdl                    => 'https://testservice.postnl.com/CIF_SB/BarcodeWebService/1_1/?wsdl',
#              :log                     => true,
#              :wsse_auth               => ['devc_!R4xc8p9', 'xxx'],
#              :pretty_print_xml        => true,
#              :convert_request_keys_to => :camelcase,
#              :env_namespace           => :s,
#              :namespace_identifier    => nil
#             )
#
#  message =  {
#               "d6p1:Message" => {
#                 "d6p1:MessageID" =>  "10",
#                 "d6p1:MessageTimeStamp" => Time.now.strftime("%d-%m-%Y %H:%M:%S")
#             },
#               "d6p1:Customer" => {
#                 "d6p1:CustomerCode" => "DEVC",
#                 "d6p1:CustomerNumber" =>  "11223344"},
#                 "d6p1:Barcode" => {
#                   "d6p1:Type" => "3S",
#                   "d6p1:Range" => "DEVC",
#                   "d6p1:Serie" => "1000000-2000000" }
#             }
#
#
# attributes = { "xmlns:d6p1" => "http://postnl.nl/cif/domain/BarcodeWebService/",
#                "xmlns:i" => "http://www.w3.org/2001/XMLSchema-instance",
#                "xmlns" => "http://postnl.nl/cif/services/BarcodeWebService/"}
#
# @client.call(:generate_barcode, :attributes => attributes,
#              :message => message,
#              :soap_header => { "Action" => "http://postnl.nl/cif/services/BarcodeWebService/IBarcodeWebService/GenerateBarcode"})

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

  def order_received_confirmation_to_customer(invoice)
    <<~EOF
      Uw bestelling is ontvangen. Deze wordt zo spoedig mogelijk naar u opgestuurd.

      Wilt u uw bestellingen volgen of uw facturen inzien?
      Op uw profiel heeft u direct toegang tot al de gegevens die u nodig heeft.

      #{root_url}users/#{invoice.order.customer.id}
    EOF
  end
end
