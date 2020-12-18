# == Schema Information
#
# Table name: applicant_entry_recruitings
#
#  id                  :bigint           not null, primary key
#  status              :integer          default("invited")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  applicant_id        :string(32)       not null
#  entry_recruiting_id :integer          not null
#
# Indexes
#
#  index_applicant_entry_recruitings_on_applicant_id         (applicant_id)
#  index_applicant_entry_recruitings_on_entry_recruiting_id  (entry_recruiting_id)
#
class ApplicantEntryRecruiting < ApplicationRecord
  belongs_to :entry_recruiting, class_name: "Recruiting"
  belongs_to :applicant, class_name: "User"

  enum status: { "invited": 0, "participating": 1}

end
