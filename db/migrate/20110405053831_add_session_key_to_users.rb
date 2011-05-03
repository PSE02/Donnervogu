class AddSessionKeyToUsers < ActiveRecord::Migration
def self.up
 change_table :users do |t|
  add_column :users, :session_key, :string
 end
end

def self.down
 remove_column :users, :session_key
end
end
