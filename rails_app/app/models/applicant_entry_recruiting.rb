# == Schema Information
#
# Table name: applicant_entry_recruitings
#
#  id                  :bigint           not null, primary key
#  status              :integer          default("unapproved")
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
  after_update_commit do
    update_with_recruiting if saved_change_to_status?
  end

  belongs_to :entry_recruiting, class_name: "Recruiting"
  belongs_to :applicant, class_name: "User"

  validate :recruiting_open?
  validate :recruiting_unfilled?
  validate :applicant_is_not_owner?

  enum status: { "unapproved": 0, "approved": 1}


  private

  def recruiting_open?
    errors.add(:entry_recruiting, 'その募集は既に閉じられています') if self.entry_recruiting.close?
  end


  def recruiting_unfilled?
    errors.add(:entry_recruiting, 'その募集は既に満員です') if self.entry_recruiting.recruitment_numbers <= 0
  end


  def applicant_is_not_owner?
    errors.add(:applicant, 'あなた自身がかけた募集には応募できません') if self.entry_recruiting.user_id == self.applicant_id
  end

  #for after_update
  def update_with_recruiting
    recruting = self.entry_recruiting

    if self.approved?
      recruting.adopt
    else
      recruting.reject
    end
  end

end