# == Schema Information
#
# Table name: recruitings
#
#  id                  :bigint           not null, primary key
#  comment             :text
#  game_mode           :integer
#  play_style          :text
#  rank                :integer
#  recruitment_numbers :integer
#  status              :integer          default("open"), not null
#  type                :string           not null
#  vc                  :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :string(32)       not null
#
class Recruiting < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true, uniqueness: true, length: { maximum: 32 }
  validates :type,  presence: true
  validates :recruitment_numbers,  presence: true
  validates :play_style, length: { maximum: 32 }
  validates :comment, length: { maximum: 255 }

  validate :type_include_game_name?


  scope :status_open,   -> { where(status: 'open') }
  scope :apex_type,     -> { where(type: 'ApexRecruiting') }


  enum vc: { 
    "off": 0,
    "on": 1
  }


  enum status: { 
    "open": 0,
    "close": 1
  }



  #list of game type.
  GAMETYPENAMES = ['ApexRecruiting']

  def type_include_game_name?
    if type.present? && !GAMETYPENAMES.include?(type)
      errors.add(:type, " 指定のゲームは募集できません")
    end
  end

end
