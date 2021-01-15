# == Schema Information
#
# Table name: notices
#
#  id            :bigint           not null, primary key
#  content       :text
#  status        :integer          default("未読"), not null
#  title         :string
#  type          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  applicant_id  :string
#  recruiting_id :integer
#  user_id       :string
#
# Indexes
#
#  index_notices_on_user_id  (user_id)
#
class DeleteEntryNotice < Notice
  validates :reason_for_delete_entry,  presence: true
  #enum reason_for_delete_entry: { "reject": 0, "decline": 1, "kick": 2}
end
