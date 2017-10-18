class AddLabelDataToRuns < ActiveRecord::Migration[5.0]
  def change
    add_column :runs, :label_data, :text
  end
end
