FactoryBot.define do

  factory :valid_delete_entry_notice, class: DeleteEntryNotice do
    type {'DeleteEntryNotice'}
    title {'参加申請が拒否されました'}
    status { '未読' }
    reason_for_delete_entry { 'refusal'}

    after(:build) do |notice|
      owner = create(:recruiter, :user_with_applicant)
      recruiting = owner.recruiting

      #参加拒否された募集IDをセット
      notice.recruiting_id = recruiting.id

      #参加申請を拒否されたユーザーを通知受取人としてセット（実際にエントリーをdeleteはしない。）
      notice.user_id = recruiting.applicants[0].user_id
    end
  end

end

