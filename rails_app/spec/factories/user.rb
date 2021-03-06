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


  factory :recruiter, class: User do
    user_id { "recruiter_id" }
    password { valid_password }
    trait :user_with_recruiting do
      after(:create) do |user|
        user.create_recruiting(attributes_for(:recruiting_mock))
      end
    end

    trait :user_with_applicant do
      after(:create) do |user|
        user.create_recruiting(attributes_for(:recruiting_mock))
        user.recruiting.applicants << create(:valid_users)
      end
    end
  end


  factory :recruiters, class: User do
    sequence(:user_id) { |n| "valid_user_id_#{n}" }
    password { valid_password }

    transient do
      rank { 'ブロンズ' }
    end

    after(:create) do |user, evaluator|
      user.create_recruiting(attributes_for(:recruiting_mock, rank: evaluator.rank))
    end
  end


  factory :applying_user, class: User do
    user_id { "applying_user_id" }
    password { valid_password }
    trait :user_with_entry_recruiting do
      after(:build) do |user|
        user.entry_recruiting = create(:valid_recruiting)
      end
    end
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