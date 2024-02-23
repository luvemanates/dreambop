class AddAvailability < ActiveRecord::Migration[7.1]
  def self.up
    add_column :products, :availability, :string, :default => 'NA'
  end

  def self.down
    remove_column :products, :availability
  end
end
