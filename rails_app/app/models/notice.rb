# == Schema Information
#
# Table name: notices
#
#  id         :bigint           not null, primary key
#  content    :text
#  status     :integer
#  title      :string
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :string
#
# Indexes
#
#  index_notices_on_user_id  (user_id)
#
class Notice < ApplicationRecord
  belongs_to :user

  enum status: { "未読": 0, "既読": 1}
end
