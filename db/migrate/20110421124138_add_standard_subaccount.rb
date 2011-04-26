class AddStandardSubaccount < ActiveRecord::Migration
  def self.up
    change_table :emailaccounts do |t|
      t.references :standard_subaccount
    end
  end

  def self.down
    remove_column :emailaccounts, :standard_subaccount
  end
end
