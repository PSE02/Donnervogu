class CreateLogMessages < ActiveRecord::Migration
  def self.up
    create_table :log_messages do |t|
      t.text :message
      t.references :profile

      t.timestamps
    end
  end

  def self.down
    drop_table :log_messages
  end
end
