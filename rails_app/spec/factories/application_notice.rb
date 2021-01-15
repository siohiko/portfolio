FactoryBot.define do

  factory :valid_application_notice, class: ApplicationNotice do
    type {'ApplicationNotice'}
    title {'タイトル'}
    content { '内容' }
    status { '未読' }

    after(:build) do |notice|
      owner = create(:recruiter, :user_with_applicant)
      notice.user_id = owner.user_id
      notice.recruiting_id = owner.recruiting.id
      notice.applicant_id = owner.recruiting.applicants[0].user_id
    end
  end

end

