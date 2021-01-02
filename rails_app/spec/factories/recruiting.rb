FactoryBot.define do

  factory :valid_recruiting, class: Recruiting do
    association :user, factory: :valid_user
    type {'ApexRecruiting'}
    vc { 'on' }
    recruitment_numbers { 2 }
    play_style { 'pro' }
    status { 'open' }
    comment { 'hello' }

    #for apex
    rank { 'シルバー' }
    game_mode { 'ランク' }

    trait :recruiting_with_applicant do
      after(:create) do |recruiting|
        recruiting.applicants << create(:valid_users)
        recruiting.applicants << create(:valid_users)
      end
    end
  end

  factory :valid_recruitings, class: Recruiting do
    association :user, factory: :valid_users
    type {'ApexRecruiting'}
    vc { 'on' }
    recruitment_numbers { 2 }
    play_style { 'pro' }
    status { 'open' }
    comment { 'hello' }

    #for apex
    rank { 'シルバー' }
    game_mode { 'ランク' }
  end

  factory :recruiting_mock, class: Recruiting do
    type {'ApexRecruiting'}
    vc { 'on' }
    recruitment_numbers { 1 }
    play_style { 'pro' }
    status { 'open' }
    comment { 'hello' }

    #for apex
    rank { 'シルバー' }
    game_mode { 'ランク' }
  end

end
