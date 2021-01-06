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
  before_update do
    calculate_recruitment_numbers if will_save_change_to_recruitment_numbers?
  end

  belongs_to :user

  has_many :applicant_entry_recruitings,
             primary_key: :id,
             foreign_key: :entry_recruiting_id,
             dependent: :destroy
  has_many :applicants,
             class_name: "User",
             through: :applicant_entry_recruitings

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


  #応募者を承認する時の処理
  def adopt
    capacity = self.recruitment_numbers - 1

    if capacity > 0
      self.update(recruitment_numbers: capacity )
    else
      self.update(recruitment_numbers: 0, status: 'close')
    end
  end


  def reject
    capacity = self.recruitment_numbers + 1
    self.update(recruitment_numbers: capacity, status: 'open' )
  end


  def owner?(user)
    user.user_id == self.user.user_id ? true :false
  end


  def is_filled?
    participants_count = 0
    self.applicant_entry_recruitings.each do | entry |
      participants_count += 1 if entry.approved?
    end

    participants_count < self.recruitment_numbers ? false : true
  end



  class << self
    def search(params)
      if params[:search][:type] && GAMETYPENAMES.include?(params[:search][:type])
        game_model = params[:search][:type]
        game_model.constantize.search(params)
      else
        return nil
      end
    end

  end


  private

  #募集人数更新時は、既に参加しているユーザー数を換算して更新する。
  def calculate_recruitment_numbers
    participants_count = 0
    self.applicant_entry_recruitings.each do |entry|
      participants_count += 1 if entry.approved?
    end

    self.recruitment_numbers = self.recruitment_numbers - participants_count

    if self.recruitment_numbers <= 0
      self.status = 'close'
      self.recruitment_numbers = 0
    end
  end


end
