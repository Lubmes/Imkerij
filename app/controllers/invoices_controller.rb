class InvoicesController < ApplicationController

  require 'mollie/api/client'
  require 'mailgun'
  require 'combine_pdf'

  def show
    @invoice = Invoice.find(params[:id])
    @order = @invoice.order
    @customer = @order.customer
    if @invoice.invoice_delivery.nil?
      @invoice.invoice_delivery = @invoice.order.package_delivery
      @invoice.save
    end
    render :pdf       => "file_name",
           :template  => 'invoices/invoice.pdf.erb',
           :layout    => 'invoice_pdf.html'
  end

  def sent_out
    @invoice = Invoice.find(params[:id])
    @order = @invoice.order

    @invoice.closed = true
    @order.status = 'sent'

    @order.save
    @invoice.save
  end

  def refund
    @invoice = Invoice.find(params[:id])
    @order = @invoice.order

    unless @invoice.closed?
      mollie = Mollie::API::Client.new Rails.application.secrets.mollie_api_key
      payment_id = @order.payment_id

      begin
        payment  = mollie.payments.get payment_id
        # Api call.
        mollie.payments_refunds.with(payment).create(
          amount: @invoice.paid_back_in_euros,
          description: "Restitutiebedrag van uw aankoop bij Imkerij Poppendamme").payment.amount_refunded.to_f
        # Success...
        flash[:notice] = 'Uw restitutiebedrag is verzonden naar de klant. Vergeet niet de nieuwe factuur (mee) te verzenden.'
        @invoice.closed = true
        @invoice.save
        @order.status = 'paid'
        @order.save
      rescue Mollie::API::Exception => e
        flash.now[:alert] = 'De restitutie lijkt niet te zijn uitgevoerd. Ga naar https://www.mollie.com/dashboard voor directe controle.' + e.message
      end
    end

    redirect_to @invoice.order.customer
  end

  def print
    @invoice = Invoice.find(params[:id])
    @order = @invoice.order
    @customer = @order.customer

    pdf_data = WickedPdf.new.pdf_from_string(
      render_to_string(
        :pdf          => 'file_name',
        :template     => 'invoices/invoice.pdf.erb',
        :layout       => 'invoice_pdf.html'
    ))
    pdf = CombinePDF.parse(pdf_data)


    mg_client = Mailgun::Client.new Rails.application.secrets.mailgun_api_key
    mb_object = Mailgun::MessageBuilder.new

    mb_object.add_attachment send_data pdf.to_pdf, :disposition => 'inline', :type => "application/pdf"
    mg_client.send_message 'mg.rexcopa.nl', mb_object
  end

  private

  # def pdf_attachment_method(invoice_id)
  #   @invoice = Invoice.find(invoice_id)
  #   @order = @invoice.order
  #   @customer = @order.customer
  #   doc = WickedPdf.new.pdf_from_string(
  #     render_to_string(pdf: 'invoice', template: 'invoices/invoice.pdf.erb', layout: 'invoice_pdf')
  #   )
  #   # mail(to: invoice.owner.email, subject: 'Your invoice PDF is attached', invoice: todo)
  #   mg_client = Mailgun::Client.new 'key-e762523fb38e1f94ad6336e03f5792c6'
  #   mb_object = Mailgun::MessageBuilder.new
  #
  #   mb_object.add_attachment doc#, "invoice_#{@invoice.id}.pdf"
  #   mg_client.send_message 'mg.rexcopa.nl', mb_object
  # end

  # def invoice_pdf
  #   invoice = Invoice.find(params[:id])
  #   InvoicePdf.new(invoice)
  # end
  #
  # def send_invoice_pdf
  #   send_file invoice_pdf.to_pdf,
  #     filename: invoice_pdf.filename,
  #     type: "application/pdf",
  #     disposition: "inline"
  # end

end
