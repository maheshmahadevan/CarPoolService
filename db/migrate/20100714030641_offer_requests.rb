class OfferRequests < ActiveRecord::Migration
  def self.up
	create_table :offer_requests  do |t|
	t.column :requestType, :string, :limit => 1, :null => false
	t.column :startPoint, :text, :null => false
	t.column :endPoint, :text, :null => false
	t.column :date, :date, :null => false
	t.column :time, :time, :null => false
	t.column :additionalText, :text 
	t.column :searchType, :string, :limit => 50, :null => false
	t.column :madeby, :string, :limit => 50, :null => false
   end
  end

  def self.down
    drop_table :offer_requests
  end
end
