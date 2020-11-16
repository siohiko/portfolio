FactoryBot.define do

  valid_password = "valid_password"
  
  #正当なユーザー
  factory :valid_user, class: User do
    sequence(:user_id) { |n| "valid_user_id_#{n}" }
    password { valid_password }
  end

  #ユーザーIDが不適切なユーザー
  factory :invalid_user_id_user, class: User do
    user_id { "" }
    password { valid_password }
  end

  #passwordが不適切なユーザー
  factory :invalid_password_user, class: User do
    user_id { "invalid_password_user" }
    password { "" }
  end

end