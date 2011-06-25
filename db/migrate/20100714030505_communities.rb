class Communities < ActiveRecord::Migration
  def self.up
  create_table :communities  do |t|
	t.column :name, :string, :limit => 50, :null => false
	t.column :type, :string, :limit => 20, :null => false
	t.column :city, :string, :limit => 30, :null => false
	t.column :state, :string, :limit => 2, :null => false
	t.column :message, :text
	t.column :moderator, :string, :limit => 50, :null => false
   end
  end

  def self.down
    drop_table :communities
  end
end
