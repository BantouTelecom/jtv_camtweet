class AddInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.text :invitee_screen_name
      t.text :inviter_screen_name
      t.boolean :accepted
      t.timestamps
    end
    
    add_column :users, :invites, :integer, :default => 3
    User.update_all "invites = 3"
  end

  def self.down
    drop_table :invites
    remove_column :users, :invites
  end
end
