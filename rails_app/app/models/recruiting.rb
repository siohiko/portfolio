class Recruiting < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true, uniqueness: true
  validates :type,  presence: true
  validates :recruitment_numbers,  presence: true

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
