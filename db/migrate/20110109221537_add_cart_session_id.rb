class AddCartSessionId < ActiveRecord::Migration[7.1]
  def self.up
    add_column :carts, :session_id, :string, :default => ''
  end

  def self.down
    remove_column :carts, :session_id
  end
end
