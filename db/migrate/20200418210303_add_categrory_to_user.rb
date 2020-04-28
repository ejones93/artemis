class AddCategroryToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :current_outdoor_hc, :integer
    add_column :users, :current_indoor_hc, :integer
    add_column :users, :current_outdoor_class, :string
    add_column :users, :current_indoor_class, :string
    add_column :users, :age_group, :integer
    add_column :users, :gender, :string
    add_column :users, :default_bowtype, :string
    add_column :users, :category, :integer
  end
end
