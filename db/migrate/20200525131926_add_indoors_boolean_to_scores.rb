class AddIndoorsBooleanToScores < ActiveRecord::Migration[6.0]
  def change
    add_column :scores, :indoor, :boolean
  end
end
