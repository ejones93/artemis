class ChangeScoreClassificiationToClassification < ActiveRecord::Migration[6.0]
  def change
    rename_column :scores, :classificiation, :classification
  end
end
