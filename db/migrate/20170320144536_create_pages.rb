class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.string :link
      t.string :title
      t.text :introduction
      t.boolean :route
      t.text :story

      t.timestamps
    end
  end
end
