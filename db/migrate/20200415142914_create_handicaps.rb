class CreateHandicaps < ActiveRecord::Migration[6.0]
  def change
    create_table :handicaps do |t|
      t.integer :round_id
      t.string :round_name
      t.integer :value
      t.integer :score

    end
  end
end
