class Users < ActiveRecord::Migration
  def self.up
   create_table :users  do |t|
	t.column :email, :string, :limit => 50, :null => false
	t.column :password, :string, :limit => 20, :null => false
	t.column :dob, :date, :null => false
	t.column :sex, :string, :limit => 1, :null => false
	t.column :location, :string, :limit => 20, :null => false
	t.column :type, :string, :limit => 20, :null => false
	t.column :cre_date_time, :timestamp
   end
  end

  def self.down
    drop_table :users
  end
end
