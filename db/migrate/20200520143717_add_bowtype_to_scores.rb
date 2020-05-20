class AddBowtypeToScores < ActiveRecord::Migration[6.0]
  def change
    add_column :scores, :bowtype, :string
  end
end
