class CodeReviewFixup < ActiveRecord::Migration
  def self.up
    rename_table :subaccounts, :profile_ids
    rename_column :profile_ids, :last_get, :time_of_last_ok
  end

  def self.down
    rename_column :profile_ids, :time_of_last_ok, :last_get
    rename_table :profile_ids, :subaccounts
  end
end
