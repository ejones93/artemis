class ChangeRoundsDistancesToStrings < ActiveRecord::Migration[6.0]
  def change
  change_column :rounds, :distance_1, :string
  change_column :rounds, :distance_2, :string
  change_column :rounds, :distance_3, :string
  change_column :rounds, :distance_4, :string
  end
end
