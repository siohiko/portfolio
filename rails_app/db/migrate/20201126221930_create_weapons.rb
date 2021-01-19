class CreateWeapons < ActiveRecord::Migration[6.0]
  def change
    create_table :weapons do |t|
      t.string "name", null: false
      t.integer "category", null: false
      t.timestamps
    end
  end
end
