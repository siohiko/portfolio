# == Schema Information
#
# Table name: weapons
#
#  id         :bigint           not null, primary key
#  category   :integer          not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Weapon < ApplicationRecord
  has_many :favorite_weapons
  has_many :apex_profiles, through: :favorite_weapons

  enum category: { 
    "アサルトライフル": 0,
    "サブマシンガン": 1,
    "ライトマシンガン": 2,
    "スナイパーライフル": 3,
    "ショットガン": 4,
    "ピストル": 5
  }
end
