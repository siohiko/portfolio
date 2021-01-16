FactoryBot.define do

  factory :valid_adoption_notice, class: AdoptionNotice do
    type {'AdoptionNotice'}
    title {'参加申請が承認されました'}
    content { '内容' }
    status { 'unread' }

    after(:build) do |notice|
      owner = create(:recruiter, :user_with_applicant)
      recruiting = owner.recruiting
      recruiting.applicant_entry_recruitings[0].approved!
      notice.recruiting_id = recruiting.id
      notice.user_id = recruiting.applicants[0].user_id
    end
  end

end

