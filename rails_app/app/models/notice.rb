# == Schema Information
#
# Table name: notices
#
#  id                      :bigint           not null, primary key
#  content                 :text
#  reason_for_delete_entry :integer          default(0), not null
#  status                  :integer          default(unread), not null
#  title                   :string
#  type                    :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  applicant_id            :string
#  recruiting_id           :integer
#  user_id                 :string
#
# Indexes
#
#  index_notices_on_user_id  (user_id)
#
class Notice < ApplicationRecord
  belongs_to :user

  validates :content, length: { maximum: 255 }
  validate :valid_type?

  default_scope -> { order(created_at: :desc) }

  enum status: { "unread": 0, "read": 1}

  #list of game type.
  NOTICETYPE = [
    'ApplicationNotice',
    'AdoptionNotice',
    'DeleteEntryNotice'
  ]

  private

  def valid_type?
    if type.present? && NOTICETYPE.exclude?(type)
      errors.add(:type, "指定のタイプの通知は作成できません")
    end
  end
end
