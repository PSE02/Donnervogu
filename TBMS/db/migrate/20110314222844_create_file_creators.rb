class CreateFileCreators < ActiveRecord::Migration
  def self.up
    create_table :file_creators do |t|
	  t.string :zipPath
      t.timestamps
    end
  end

  def self.down
    drop_table :file_creators
  end
end
