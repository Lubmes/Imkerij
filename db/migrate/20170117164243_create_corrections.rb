class CreateCorrections < ActiveRecord::Migration[5.0]
  def change
    create_table :corrections do |t|
      t.integer :quantity
      
      t.references :booking, index: true, foreign_key: true
      t.references :invoice, index: true, foreign_key: true
    end
  end
end
