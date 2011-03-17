class CreateSetups < ActiveRecord::Migration
  def self.up
    create_table :setups do |t|
      t.string :name
      t.boolean :enable

      t.timestamps
    end
  end

  def self.down
    drop_table :setups
  end
end
