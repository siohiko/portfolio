FactoryBot.define do

  valid_password = "valid_password"
  
  # ========== #
  # valid_user #
  # ========== #
  factory :valid_user, class: User do
    user_id { "valid_user_id" }
    password { valid_password }
  end

  factory :valid_users, class: User do
    sequence(:user_id) { |n| "valid_user_id_#{n}" }
    password { valid_password }
  end
  
  # ========== #
  # invalid_user #
  # ========== #
  factory :no_user_id, class: User do
    user_id { "" }
    password { valid_password }
  end

  factory :no_password, class: User do
    user_id { "valid_user_id" }
    password { "" }
  end

end