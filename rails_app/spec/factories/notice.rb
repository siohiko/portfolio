FactoryBot.define do

  factory :valid_notice, class: Notice do
    association :user, factory: :valid_user
    type {'application_notice'}
    title {'タイトル'}
    content { '内容' }
    status { '未読' }
  end

end
