class AddDefaultAddress < ActiveRecord::Migration[7.1]
  def self.up
    add_column :shipping_addresses, :current_default, :boolean, :default => false
  end

  def self.down
    remove_column :shipping_addresses, :current_default
  end
end
