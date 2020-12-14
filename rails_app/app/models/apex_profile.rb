# == Schema Information
#
# Table name: apex_profiles
#
#  id         :bigint           not null, primary key
#  level      :integer
#  platform   :integer
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  apex_id    :string(32)
#  user_id    :string(32)
#
# Indexes
#
#  index_apex_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.user_id)
#
class ApexProfile < ApplicationRecord
  belongs_to :user
  has_many :favorite_legends
  has_many :legends, through: :favorite_legends

  has_many :favorite_weapons
  has_many :weapons, through: :favorite_weapons

  validates :user_id, presence: true, uniqueness: true, length: { maximum: 32 }
  validates :apex_id, length: { maximum: 32 }

  enum rank: { 
    "ブロンズ": 0,
    "シルバー": 1,
    "ゴールド": 2,
    "プラチナ": 3,
    "ダイヤ": 4,
    "マスター": 5,
    "プレデター": 6
  }

  enum platform: { 
    "PC": 0,
    "PS4": 1,
    "XBOX": 2
  }

end
