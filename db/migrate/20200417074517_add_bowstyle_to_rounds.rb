class AddBowstyleToRounds < ActiveRecord::Migration[6.0]
  def change
    add_column :rounds, :bowstyle, :string 
    add_column :handicaps, :round_name, :string 
  end
end
