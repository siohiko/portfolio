class CreateNotices < ActiveRecord::Migration[6.0]
  def change
    create_table :notices do |t|
      t.string :type, null: false
      t.string :title
      t.text :content
      t.integer :status
      t.string :user_id, index: true, foreign_key: true
      t.timestamps
    end
  end
end
