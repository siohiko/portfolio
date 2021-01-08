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
  validate :validation_recruitment_numbers, on: :update


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


  def owner?(user)
    user.user_id == self.user.user_id ? true :false
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

  #募集人数更新時は、既に参加しているユーザー数を下回っていないか確認する
  def validation_recruitment_numbers
    #募集人数が無い場合、precenseバリデーションで引っかかるのでここではすぐに返す
    return unless self.recruitment_numbers

    participants_count = 0
    self.applicant_entry_recruitings.each do |entry|
      participants_count += 1 if entry.approved?
    end

    if self.recruitment_numbers <= participants_count
      errors.add(:recruitment_numbers, '既に参加者しているメンバー数以下の値には設定できません。')
    end
  end


end
