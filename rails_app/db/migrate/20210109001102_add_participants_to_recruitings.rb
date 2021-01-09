class AddParticipantsToRecruitings < ActiveRecord::Migration[6.0]
  def change
    add_column :recruitings, :participants_numbers, :integer, default: 0
  end
end
