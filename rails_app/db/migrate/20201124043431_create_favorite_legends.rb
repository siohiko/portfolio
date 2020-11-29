class CreateFavoriteLegends < ActiveRecord::Migration[6.0]
  def change
    create_table :favorite_legends do |t|
      t.integer :apex_profile_id, index: true
      t.integer :legend_id, index: true
      t.timestamps
    end
  end
end
