class AddClassesAndHandicapsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :outdoor_barebow_class, :string
    add_column :users, :outdoor_barebow_hc, :integer
    add_column :users, :indoor_barebow_class, :string
    add_column :users, :indoor_barebow_hc, :integer
    add_column :users, :outdoor_compound_class, :string
    add_column :users, :outdoor_compound_hc, :integer
    add_column :users, :indoor_compound_class, :string
    add_column :users, :indoor_compound_hc, :integer
    add_column :users, :outdoor_longbow_class, :string
    add_column :users, :outdoor_longbow_hc, :integer
    add_column :users, :indoor_longbow_class, :string
    add_column :users, :indoor_longbow_hc, :integer
    add_column :users, :outdoor_recurve_class, :string
    add_column :users, :outdoor_recurve_hc, :integer
    add_column :users, :indoor_recurve_class, :string
    add_column :users, :indoor_recurve_hc, :integer
  end
end
