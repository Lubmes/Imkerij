class CreatePictures < ActiveRecord::Migration[5.0]
  def change
    create_table :pictures do |t|
      t.string :name
      t.boolean :visable, default: true
      t.references :imageable, polymorphic: true, index: true
      t.timestamps
    end

    add_attachment :pictures, :image
  end
end