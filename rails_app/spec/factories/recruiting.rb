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
  end

end
