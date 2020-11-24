FactoryBot.define do

  factory :valid_apex_profile, class: ApexProfile do
    association :user, factory: :valid_user
    apex_id { "valid_apex_id" }
    rank { 1 }
    level { 100 }
    platform { 1 }
  end

end