class AddShippingSessionId < ActiveRecord::Migration[7.1]
  def self.up
    add_column :shipping_addresses, :session_id, :string, :default => ''
  end

  def self.down
    remove_column :shipping_addresses, :session_id
  end
end
