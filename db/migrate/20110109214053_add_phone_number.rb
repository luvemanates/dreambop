class AddPhoneNumber < ActiveRecord::Migration[7.1]
  def self.up
    add_column :credit_cards, :phone_number, :string, :default => '5305148831'
  end

  def self.down
    remove_column :credit_cards, :phone_number
  end
end
