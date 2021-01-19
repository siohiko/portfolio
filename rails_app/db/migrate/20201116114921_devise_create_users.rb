# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: false do |t|
      ## Database authenticatable
      t.string :user_id,              null: false, limit: 32, primary_key: true
      t.string :encrypted_password,   null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at
      t.timestamps null: false

      t.string :name, limit: 16
      t.integer :sex,         null: false, default: 0
      t.integer :age
      t.text :introduce, limit: 255
    end

    add_index :users, :user_id,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
