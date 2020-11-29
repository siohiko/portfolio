FactoryBot.define do

  factory :wraith, class: Legend do
    id {0}
    name { "レイス" }
    icon_path { "wraith" }
  end

  factory :wattson, class: Legend do
    id {1}
    name { "ワットソン" }
    icon_path { "wattson" }
  end

end