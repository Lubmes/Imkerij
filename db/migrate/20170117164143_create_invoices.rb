class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.boolean :closed, default: false
      t.integer :total_mail_weight, :default => 0
      t.references :order, index: true, foreign_key: true

      t.timestamps
    end

    add_monetize :invoices, :paid
    add_monetize :invoices, :paid_back

    add_reference :invoices, :invoice_delivery, index: true
    add_foreign_key :invoices, :deliveries, column: :invoice_delivery_id
  end
end
