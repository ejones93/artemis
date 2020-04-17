class CreateRounds < ActiveRecord::Migration[6.0]
  def change
    drop_table :rounds
    create_table :rounds do |t|
      t.string :name
      t.boolean :indoor
      t.string :organisation
      t.integer :max_hits
      t.integer :max_score

    end
  end
end
