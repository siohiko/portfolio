class CreateApplicants < ActiveRecord::Migration[6.0]
  def change
    create_table :applicant_entry_recruitings do |t|
      t.string :applicant_id, null: false, limit: 32
      t.integer :entry_recruiting_id, null: false
      t.integer :status, default: 0
      t.timestamps
    end

    add_index :applicant_entry_recruitings, :applicant_id
    add_index :applicant_entry_recruitings, :entry_recruiting_id
  end
end
