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
  attr_accessor :message, :delete_reason

  after_create do
    #応募があったことを通知する
    create_application_notice(
      owner_id: entry_recruiting.user_id,
      applicant_id: applicant_id,
      recruiting_id: entry_recruiting_id,
      content: message
    )
  end

  after_update_commit do
    if saved_change_to_status? && approved?
      increase_participants_numbers_and_update_status
      create_adoption_notice(
        applicant_id: applicant_id,
        recruiting_id: entry_recruiting_id
      )
    end
  end

  after_destroy do
    decrease_participants_numbers_and_update_status if approved?
    create_delete_entry_notice(delete_reason) if self.delete_reason
  end



  belongs_to :entry_recruiting, class_name: "Recruiting"
  belongs_to :applicant, class_name: "User"

  validate :recruiting_open?
  validate :applicant_is_not_owner?
  validate :check_vacancy_of_recruiting, on: :update

  enum status: { "unapproved": 0, "approved": 1}


  private

  def recruiting_open?
    errors.add(:entry_recruiting, 'その募集には応募できません') unless entry_recruiting.open?
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
  def increase_participants_numbers_and_update_status
    entry_recruiting.participants_numbers += 1

    #もし参加人数と募集人数が同じになったら自動的に状態を満員に更新
    if entry_recruiting.recruitment_numbers === entry_recruiting.participants_numbers
      entry_recruiting.status = 'filled'
    end

    #FIX ME!!!!
    #現状ここで更新失敗することはないが、いつかに備えてエラーハンドリングは必要。
    entry_recruiting.save
  end


  #キック時、レコードを消去すると共に、関連するRecruitingレコードの参加人数を更新し、それに応じて状態も更新をする
  def decrease_participants_numbers_and_update_status
    entry_recruiting.participants_numbers -= 1
    
    #もし募集状態が満員状態であったなら、１枠空いたので公開中にする
    if entry_recruiting.filled?
      entry_recruiting.status = 'open'
    end

    #FIX ME!!!!
    #現状ここで更新失敗することはないが、いつかに備えてエラーハンドリングは必要。
    entry_recruiting.save
  end


  def create_application_notice(owner_id:, applicant_id:, recruiting_id:, content:)
    notice = ApplicationNotice.new(
        type: 'ApplicationNotice',
        title: '参加申請のお知らせ',
        user_id: owner_id,
        applicant_id: applicant_id,
        recruiting_id: recruiting_id,
        content: content
      )

    if notice.save
      return true
    else
      return false
    end
  end


  def create_adoption_notice(applicant_id:, recruiting_id:)
    notice = AdoptionNotice.new(
        type: 'AdoptionNotice',
        title: '参加承認のお知らせ',
        user_id: applicant_id,
        recruiting_id: recruiting_id
      )

    if notice.save
      return true
    else
      return false
    end
  end


  def create_delete_entry_notice(reason)
    
    notice = DeleteEntryNotice.create_for_reason(
      reason: delete_reason,
      recruiting_id: entry_recruiting_id,
      owner_id: entry_recruiting.user_id,
      applicant_id: applicant_id
    )

    if notice
      return true
    else
      return false
    end
  end
end