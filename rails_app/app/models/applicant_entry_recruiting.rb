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
    update_with_recruiting_status if saved_change_to_status?
  end

  belongs_to :entry_recruiting, class_name: "Recruiting"
  belongs_to :applicant, class_name: "User"

  validate :recruiting_open?
  validate :applicant_is_not_owner?
  validate :check_vacancy_of_recruiting, on: :update

  enum status: { "unapproved": 0, "approved": 1}


  private

  def recruiting_open?
    errors.add(:entry_recruiting, 'その募集は既に閉じられています') if entry_recruiting.close?
  end


  def applicant_is_not_owner?
    errors.add(:applicant, 'あなた自身がかけた募集には応募できません') if entry_recruiting.user_id == self.applicant_id
  end


  #stautsをapprovedに更新する時、参加者数が募集人数を超えないように確認する
  def check_vacancy_of_recruiting
    if will_save_change_to_status? && self.approved?

      if entry_recruiting.recruitment_numbers <= entry_recruiting.participants_numbers
        errors.add(:status, 'この募集は既に満員です。募集人数を設定しなおしてください。')
      end
    end
  end


  #自身のstatusをapprovedに更新成功時、関連するRecruitingレコードの参加人数を更新し、それに応じて状態も更新をする
  def update_with_recruiting_status
    if self.saved_change_to_status? && self.approved?
      #まずは参加人数を更新
      entry_recruiting.participants_numbers += 1

      #もし参加人数と募集人数が同じになったら自動的に状態を満員に更新
      if entry_recruiting.recruitment_numbers === entry_recruiting.participants_numbers
        entry_recruiting.status = 'filled'
      end

      #FIX ME!!!!
      #現状ここで更新失敗することはないが、いつかに備えてエラーハンドリングは必要。
      entry_recruiting.save
    end
  end

end