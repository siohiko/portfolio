FactoryBot.define do

  factory :valid_recruiting, class: Recruiting do
    association :user, factory: :valid_user
    type {'ApexRecruiting'}
    vc { 0 }
    recruitment_numbers { 2 }
    play_style { 'pro' }
    status { 0 }
    comment { 'hello' }

    #for apex
    rank { 1 }
    game_mode { 0 }
  end

end
