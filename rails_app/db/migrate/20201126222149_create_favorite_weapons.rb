class CreateFavoriteWeapons < ActiveRecord::Migration[6.0]
  def change
    create_table :favorite_weapons do |t|
      t.integer :apex_profile_id, index: true
      t.integer :weapon_id, index: true
      t.timestamps
    end
  end
end
