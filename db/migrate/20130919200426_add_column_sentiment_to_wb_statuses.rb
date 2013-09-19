class AddColumnSentimentToWbStatuses < ActiveRecord::Migration
  def change
  	add_column :wb_statuses, :sentiment, :float, limit: 30
  end
end
