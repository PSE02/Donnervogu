class AddTimeOfLastConnection < ActiveRecord::Migration
  def self.up
    change_table :profile_ids do |t|
        t.timestamp :time_of_last_connection
    end
  end

  def self.down
    remove_column :profile_ids, :time_of_last_connection
  end
end
