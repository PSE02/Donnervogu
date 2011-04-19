class AddGeneralEmailaccountsInformation < ActiveRecord::Migration
  def self.up
    change_table :emailaccounts do |t|
      t.text :informations
    end
  end

  def self.down
    remove_column :emailaccounts, :informations
  end
end
