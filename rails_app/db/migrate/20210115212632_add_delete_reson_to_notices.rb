class AddDeleteResonToNotices < ActiveRecord::Migration[6.0]
  def change
    add_column :notices, :reason_for_delete_entry, :integer, null: false, default: 0
  end
end
