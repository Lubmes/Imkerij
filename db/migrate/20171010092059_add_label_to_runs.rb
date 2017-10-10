class AddLabelToRuns < ActiveRecord::Migration[5.0]
  def change
    add_attachment :runs, :label
  end
end
