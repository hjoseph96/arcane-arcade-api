class SorceryCore < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto'

    create_table :users do |t|
      t.string :username,         null: false
      t.string :email,            null: false
      t.string :crypted_password, null: false
      t.string :phone_number,     null: false
      t.string :salt

      t.timestamps                null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
end
