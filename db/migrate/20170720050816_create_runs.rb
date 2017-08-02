class CreateRuns < ActiveRecord::Migration[5.0]
  def change
    create_table :runs do |t|
      t.belongs_to :delivery, index: true
      t.belongs_to :invoice, index: true
      t.string :barcode

      t.timestamps
    end
  end
end
