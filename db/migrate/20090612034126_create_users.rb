class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.text :name
      t.text :screen_name
      t.text :password
      t.text :profile_image_url
      t.text :channel
      t.text :channel_password
      t.integer :twitter_id
      t.text :access_token
      t.text :access_token_secret

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
