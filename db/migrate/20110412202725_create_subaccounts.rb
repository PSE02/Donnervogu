class CreateSubaccounts < ActiveRecord::Migration
  def self.up
    create_table :subaccounts do |t|
      t.timestamp :last_get
      t.references :emailaccount

      t.timestamps
    end
    remove_column :emailaccounts, :last_get
  end

  def self.down
    drop_table :subaccounts
    change_table :emailaccounts do |t|
      t.timestamp :last_get
    end
  end
end
