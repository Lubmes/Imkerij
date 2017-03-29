class InvoicesController < ApplicationController
  before_action :connect_to_mollie, only: [:refund]

  require 'mollie/api/client'

  def show
    @invoice = Invoice.find(params[:id])
    @order = @invoice.order
    @customer = @order.customer
    if @invoice.invoice_delivery.nil?
      @invoice.invoice_delivery = @invoice.order.package_delivery
      @invoice.save
    end
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
    mollie = Mollie::API::Client.new 'test_EygcTKUUPHnS85C4c5x2GAQ74rnyWr'
    @invoice = Invoice.find(params[:id])
    payment  = mollie.payments.get @invoice.order.payment_id

    begin
      refund =  mollie.payments_refunds.with(payment.id).create({
                  :amount       => 2.00,
                  :description  => "#{@invoice.order.customer.first_name} #{@invoice.order.customer.last_name} restitutie"
                })

      # aanpassen
      # $response.body << "The payment #{payment.id} is now refunded.<br>"
    rescue Mollie::API::Exception => e
      # $response.body << "API call failed: " << (CGI.escapeHTML e.message)
    end

    redirect_to @invoice.order.customer
  end

  private

  def connect_to_mollie
    mollie = Mollie::API::Client.new 'test_EygcTKUUPHnS85C4c5x2GAQ74rnyWr'
  end
end
