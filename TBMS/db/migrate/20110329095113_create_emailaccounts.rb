class CreateEmailaccounts < ActiveRecord::Migration
  def self.up
    create_table :emailaccounts do |t|
      t.string :email
      t.string :name
      t.text :preferences
      t.datetime :last_get

      t.timestamps
    end
  end

  def self.down
    drop_table :emailaccounts
  end
end
