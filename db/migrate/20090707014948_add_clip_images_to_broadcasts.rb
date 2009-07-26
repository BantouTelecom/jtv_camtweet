class AddClipImagesToBroadcasts < ActiveRecord::Migration
  def self.up
    add_column :broadcasts, :clip_images, :text
  end

  def self.down
    remove_column :broadcasts, :clip_images
  end
end
