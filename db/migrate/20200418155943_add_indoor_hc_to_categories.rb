class AddIndoorHcToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :a_hc, :integer
    add_column :categories, :b_hc, :integer
    add_column :categories, :c_hc, :integer
    add_column :categories, :d_hc, :integer
    add_column :categories, :e_hc, :integer
    add_column :categories, :f_hc, :integer
    add_column :categories, :g_hc, :integer
    add_column :categories, :h_hc, :integer
  end
end
