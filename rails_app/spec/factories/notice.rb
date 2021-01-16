FactoryBot.define do

  factory :valid_notice, class: Notice do
    association :user, factory: :valid_user
    type {'ApplicationNotice'}
    title {'タイトル'}
    content { '内容' }
    status { 'unread' }
  end

end
