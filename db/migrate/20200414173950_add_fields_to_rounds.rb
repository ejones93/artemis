class AddFieldsToRounds < ActiveRecord::Migration[6.0]
  def change
    add_column :rounds, :arrows_per_end, :integer
    add_column :rounds, :distance_1, :integer
    add_column :rounds, :face_1, :integer
    add_column :rounds, :ends_1, :integer
    add_column :rounds, :distance_2, :integer
    add_column :rounds, :face_2, :integer
    add_column :rounds, :ends_2, :integer
    add_column :rounds, :distance_3, :integer
    add_column :rounds, :face_3, :integer
    add_column :rounds, :ends_3, :integer
    add_column :rounds, :distance_4, :integer
    add_column :rounds, :face_4, :integer
    add_column :rounds, :ends_4, :integer
    add_column :rounds, :notes, :text
    add_column :rounds, :gmb_achievable, :string
    add_column :rounds, :mb_achievable, :string
    add_column :rounds, :bowman_achievable, :string
    add_column :rounds, :first_achievable, :string
    add_column :rounds, :second_achievable, :string
    add_column :rounds, :third_achievable, :string
  end
end
