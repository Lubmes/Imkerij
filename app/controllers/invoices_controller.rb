class InvoicesController < ApplicationController

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


    redirect_to @invoice.order.customer
  end

end
