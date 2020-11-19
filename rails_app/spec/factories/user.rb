FactoryBot.define do

  valid_password = "valid_password"
  
  #正当なユーザー
  factory :valid_user, class: User do
    sequence(:user_id) { |n| "valid_user_id_#{n}" }
    password { valid_password }
  end

end