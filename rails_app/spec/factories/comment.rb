FactoryBot.define do

  factory :general_user_comment, class: Comment do
    association :user, factory: :valid_users
    association :recruiting, factory: :valid_recruiting
    content {'一般ユーザーのコメント'}
  end

end
