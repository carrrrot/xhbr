class RemoveColumnThumbnailPicInWbStatuses < ActiveRecord::Migration
  def change
  	remove_column :wb_statuses, :thumbnail_pic
  end
end
