class ApexProfile < ApplicationRecord
  belongs_to :user
  has_many :favorite_legends
  has_many :legends, through: :favorite_legends

  has_many :favorite_weapons
  has_many :weapons, through: :favorite_weapons

  validates :user_id, presence: true, uniqueness: true

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
