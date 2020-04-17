class RedoHandicaps < ActiveRecord::Migration[6.0]
  def change
  drop_table :handicaps
  create_table :handicaps do |t|
      t.references :round, null: false, foreign_key: true
      t.integer :value
      t.integer :score
    end
  add_index :handicaps, [:round_id, :value]
  end
end
