class InvoiceMailer < ApplicationMailer
  default from: "lmschukking@icloud.com"

  def internal_print_email(invoice)
    printer_email = 'l.m.schukking@gmail.com'
    @invoice = invoice
    mail(     to: printer_email,
            body: '',
         subject: "invoice id: #{@invoice.id}")
  end
end
