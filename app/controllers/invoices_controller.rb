class InvoicesController < ApplicationController

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

end
