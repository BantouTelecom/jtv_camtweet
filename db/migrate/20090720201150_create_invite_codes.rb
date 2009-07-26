class CreateInviteCodes < ActiveRecord::Migration
  def self.up
    create_table :invite_codes do |t|
      t.text :uid
      t.integer :available

      t.timestamps
    end
  end

  def self.down
    drop_table :invite_codes
  end
end
