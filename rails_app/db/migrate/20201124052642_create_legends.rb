class CreateLegends < ActiveRecord::Migration[6.0]
  def change
    create_table :legends do |t|
      t.string "name", null: false
      t.string "icon_path", null: false
      t.timestamps
    end
  end
end
