FactoryBot.define do

  factory :flatline, class: Weapon do
    id {0}
    name { "フラットライン" }
    category { 0 }
  end

  factory :g7, class: Weapon do
    id {1}
    name { "G7スカウト" }
    category { 0 }
  end

end