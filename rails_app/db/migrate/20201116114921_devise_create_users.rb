# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :user_id,              null: false, default: ""
      t.string :encrypted_password,   null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at
      t.timestamps null: false

      t.string :name
      t.integer :sex,         null: false, default: 0
      t.integer :age
    end

    add_index :users, :user_id,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
