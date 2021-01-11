# == Schema Information
#
# Table name: recruitings
#
#  id                   :bigint           not null, primary key
#  comment              :text
#  game_mode            :integer
#  participants_numbers :integer          default(0)
#  play_style           :text
#  rank                 :integer
#  recruitment_numbers  :integer
#  status               :integer          default("open"), not null
#  type                 :string           not null
#  vc                   :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :string(32)       not null
#
class Recruiting < ApplicationRecord
  before_update do
     update_status_with_recruitment_numbers if will_save_change_to_recruitment_numbers?
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
  validate :validation_recruitment_numbers
  validate :validation_status_update, on: :update

  default_scope -> { order(created_at: :desc) }
  scope :status_open,   -> { where(status: 'open') }
  scope :apex_type,     -> { where(type: 'ApexRecruiting') }



  enum vc: { 
    "off": 0,
    "on": 1
  }


  enum status: { 
    "open": 0,
    "close": 1,
    "filled": 2
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

    if recruitment_numbers_is_less_than_participants?
      errors.add(:recruitment_numbers, '既に参加しているメンバー数未満の値には設定できません。')
    end
  end

  #募集人数を増加時、もし募集状態が満員(filled)だったら公開中（open）にする
  def update_status_with_recruitment_numbers
    if recruitment_numbers_is_more_than_participants? && self.filled?
      self.status = 'open'
    end
  end


  #募集人数が参加者数以下のまま公開状態への変更はさせない
  def validation_status_update
    #募集人数が無い場合、precenseバリデーションで引っかかるのでここではすぐに返す
    return unless self.recruitment_numbers

    if self.open? && recruitment_numbers_is_no_more_than_participants?
      errors.add(:status, 'この募集は満員状態なので公開できません。募集人数を再設定するか、新しく募集を作成してください')
    end
  end


  def recruitment_numbers_is_less_than_participants?
    self.recruitment_numbers < self.participants_numbers ? true : false
  end


  def recruitment_numbers_is_no_more_than_participants?
    self.recruitment_numbers <= self.participants_numbers ? true : false
  end


  def recruitment_numbers_is_more_than_participants?
    self.recruitment_numbers > self.participants_numbers ? true : false
  end
end
