class CreateScores < ActiveRecord::Migration[6.0]
  def change
    create_table :scores do |t|
      t.integer :score
      t.integer :hits
      t.integer :golds
      t.integer :xs
      t.references :round, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :comment
      t.date :date
      t.string :location
      t.integer :handicap
      t.string :classificiation
      t.boolean :home
      t.boolean :club_record
      t.boolean :county_record
      t.boolean :uk_record
      t.boolean :validated

      t.timestamps
    end
    add_index :scores, [:user_id, :created_at]
  end
end
