class UserCommunities < ActiveRecord::Migration
  def self.up
	create_table :user_communities  do |t|
	t.column :user, :string, :limit => 50, :null => false
	t.column :community, :string, :limit => 50, :null => false
	t.column :moderator, :string, :limit => 1, :null => false
	end
  end

  def self.down
	drop_table :user_communities
  end
end
