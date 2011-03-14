class CreateSetups < ActiveRecord::Migration
  def self.up
    create_table :setups do |t|
      t.String :name
      t.Boolean :enable

      t.timestamps
    end
  end

  def self.down
    drop_table :setups
  end
end
