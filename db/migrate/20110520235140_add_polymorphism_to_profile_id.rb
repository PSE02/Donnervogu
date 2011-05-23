class AddPolymorphismToProfileId < ActiveRecord::Migration
  def self.up
    change_table :profile_ids do |t|
      t.string :emailaccount_type
    end
  end

  def self.down
    remove_column :profile_ids, :emailaccount_type
  end
end
