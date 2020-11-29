class CreateApexProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :apex_profiles do |t|

      t.timestamps
      t.string :user_id
      t.string :apex_id
      t.integer :rank
      t.integer :level
      t.integer :platform
    end

    add_foreign_key :apex_profiles, :users, column: :user_id, primary_key: :user_id
    add_index :apex_profiles, :user_id
  end
end
