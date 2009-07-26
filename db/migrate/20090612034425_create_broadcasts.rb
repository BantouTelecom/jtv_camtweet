class CreateBroadcasts < ActiveRecord::Migration
  def self.up
    create_table :broadcasts do |t|
      t.integer :user_id
      t.timestamp :ended_at
      t.text :status
      t.text :uid
      t.integer :clip_id

      t.timestamps
    end
  end

  def self.down
    drop_table :broadcasts
  end
end
