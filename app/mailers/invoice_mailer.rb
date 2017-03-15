class InvoiceMailer < ApplicationMailer
  default from: 'l.m.schukking@gmail.com'

  def internal_print_email(invoice)
    printer_email = 'lmschukking@icloud.com'
    @invoice = invoice
    @url  = 'http://example.com/login'
    mail(to: printer_email,
         body: '',
         subject: "invoice id: #{@invoice.id}")
  end
end
