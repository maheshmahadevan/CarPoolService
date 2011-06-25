class Notifications < ActiveRecord::Migration
  def self.up
	create_table :notifications  do |t|
	t.column :message, :text
	t.column :sender, :string, :limit => 50, :null => false
	t.column :recipient, :string, :limit => 50, :null => false
	t.column :sent_time, :timestamp
   end
  end

  def self.down
  drop_table :notifications
  end
end
