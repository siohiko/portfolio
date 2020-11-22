FactoryBot.define do

  valid_password = "valid_password"
  
  #valid_user
  factory :valid_user, class: User do
    user_id { "valid_user_id" }
    password { valid_password }
  end

end