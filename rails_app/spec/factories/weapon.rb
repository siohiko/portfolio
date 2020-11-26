FactoryBot.define do

  factory :valid_weapon, class: Weapon do
    name { "フラットライン" }
    category { 0 }
  end

end