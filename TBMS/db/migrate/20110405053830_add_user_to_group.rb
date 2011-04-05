class AddUserToGroup < ActiveRecord::Migration
  def self.up
	  change_table :emailaccounts do |t|
		  t.references :group
	  end
  end

  def self.down
	  remove_column :emailaccounts, :group
  end
end
