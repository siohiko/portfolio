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
class AdoptionNotice < Notice
  validates :recruiting_id,  presence: true
end
