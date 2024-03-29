class CreateUsers < ActiveRecord::Migration[7.1]
  def self.up
    create_table "users", :force => true do |t|
      t.string   :email,                     :limit => 100
      t.string   :crypted_password,          :limit => 40
      t.string   :activation_code,           :limit => 40
      t.string   :salt,                      :limit => 40
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :remember_token,            :limit => 40
      t.datetime :remember_token_expires_at


    end
    add_index :users, :email, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
