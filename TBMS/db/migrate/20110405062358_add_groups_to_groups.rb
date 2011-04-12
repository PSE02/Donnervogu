class AddGroupsToGroups < ActiveRecord::Migration
  def self.up
	  change_table :groups do |t|
		  t.references :group
	  end
  end

  def self.down
	  remove_column :groups, :group
  end
end
