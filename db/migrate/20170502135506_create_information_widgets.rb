class CreateInformationWidgets < ActiveRecord::Migration[5.0]
  def change
    create_table :information_widgets do |t|
      t.string :title
      t.text :information
    end
    add_reference :pages, :opening_times_widget, index: true
    add_foreign_key :pages, :information_widgets, column: :opening_times_widget_id
  end
end
