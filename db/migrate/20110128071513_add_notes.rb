class AddNotes < ActiveRecord::Migration[7.1]
  def self.up
    add_column :orders, :notes, :text
  end

  def self.down
    remove_column :orders, :notes
  end
end
