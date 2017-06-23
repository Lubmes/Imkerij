class InvoiceMailer < ApplicationMailer
  # default from: "postmaster@mg.rexcopa.nl"
  default from: "from@example.com"

  def internal_print_email(invoice)
    printer_email = 'l.m.schukking@gmail.com'
    @invoice = invoice
    mail(     to: printer_email,
            body: '',
         subject: "invoice id: #{@invoice.id}")
  end

  def paid_notification(invoice, user)
    @user = user
    @invoice = invoice
    @greeting = "Hello"
    mail( :to       => "lmschukking@icloud.com",
          :subject  => "Mail uit de invoice mailer!"
    )
  end
end
