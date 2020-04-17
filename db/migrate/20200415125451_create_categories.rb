class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :bowtype
      t.string :gender
      t.integer :age
      t.integer :gmb_hc
      t.integer :mb_hc
      t.integer :bowman_hc
      t.integer :first_hc
      t.integer :second_hc
      t.integer :third_hc
    end
  end
end
