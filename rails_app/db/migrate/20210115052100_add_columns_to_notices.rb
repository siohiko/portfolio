class AddColumnsToNotices < ActiveRecord::Migration[6.0]
  def change
    add_column :notices, :applicant_id, :string
    add_column :notices, :recruiting_id, :integer
  end
end
