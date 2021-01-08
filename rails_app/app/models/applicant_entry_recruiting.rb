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


  #participants_countのゲッター（初期化時に下記処理をやると、必要無いときもSQLクエリ走るのでここで行う）
  def participants_count
    unless @participants_count
      @participants_count = 0
      entry_recruiting.applicant_entry_recruitings.each do |entry|
        @participants_count += 1 if entry.approved?
      end
    end

    return @participants_count
  end

  private

  def recruiting_open?
    errors.add(:entry_recruiting, 'その募集は既に閉じられています') if entry_recruiting.close?
  end


  def applicant_is_not_owner?
    errors.add(:applicant, 'あなた自身がかけた募集には応募できません') if entry_recruiting.user_id == self.applicant_id
  end


  #stautsをapprovedに更新する時、参加者数が募集人数を超えないように確認する
  def check_vacancy_of_recruiting
    return true if self.unapproved?

    if entry_recruiting.recruitment_numbers <= participants_count
      errors.add(:status, 'この募集は既に満員です。募集人数を設定しなおしてください。')
    end
  end


  #自身のstatusをapprovedに更新時、参加者人数が募集人数に達したら関連している募集をclosedにする
  def update_with_recruiting_status
    return unless self.approved?

    count = participants_count
    count += 1 

    if entry_recruiting.recruitment_numbers === count
      entry_recruiting.close!
    end
  end

end