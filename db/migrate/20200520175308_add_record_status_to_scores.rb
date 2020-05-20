class AddRecordStatusToScores < ActiveRecord::Migration[6.0]
  def change
    add_column :scores, :record_status, :string
  end
end
