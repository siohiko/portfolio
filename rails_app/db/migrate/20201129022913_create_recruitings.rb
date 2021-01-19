class CreateRecruitings < ActiveRecord::Migration[6.0]
  def change
    create_table :recruitings do |t|

      t.string :type, null: false
      t.string :user_id, null: false, limit: 32
      t.integer :vc
      t.integer :recruitment_numbers
      t.text :play_style, limit: 32
      t.integer :status, null: false, default: 0
      t.text :comment, limit: 255

      #for apex
      t.integer :rank
      t.integer :game_mode

      t.timestamps
    end
  end
end
