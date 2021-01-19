class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.string :user_id, index: true, foreign_key: true
      t.integer :recruiting_id, index: true, foreign_key: true
      t.timestamps
    end
  end
end
