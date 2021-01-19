# == Schema Information
#
# Table name: users
#
#  age                    :integer
#  encrypted_password     :string           default(""), not null
#  introduce              :text
#  name                   :string(16)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sex                    :integer          default("男性"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_id                :string(32)       not null, primary key
#
# Indexes
#
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_user_id               (user_id) UNIQUE
#
class User < ApplicationRecord
  has_one :apex_profile, dependent: :destroy, primary_key: :user_id, foreign_key: :user_id
  has_one :recruiting, dependent: :destroy, primary_key: :user_id, foreign_key: :user_id

  has_one :applicant_entry_recruiting,
            primary_key: :user_id,
            foreign_key: :applicant_id,
            dependent: :destroy
  has_one :entry_recruiting,
            class_name: "Recruiting",
            through: :applicant_entry_recruiting

  has_many :notices,
             dependent: :destroy

  has_many :comments,
             dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :authentication_keys => [:user_id]

  devise :validatable, password_length: 8..128
  validates :user_id, presence: true, uniqueness: true, length: { maximum: 32 }
  validates :name, length: { maximum: 16 }
  validates :introduce, length: { maximum: 255 }


  enum sex: { "男性": 0, "女性": 1}


  #emaiをdeviseで使わない設定
  def email_required?
    false
  end

  #emaiをdeviseで使わない設定
  def email_changed?
    false
  end
  
  #emaiをdeviseで使わない設定（モンキーパッチ）
  def will_save_change_to_email?
    false
  end

  #アップデート時にはパスワードを使用しない
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end


  #引数の募集オブジェクトに対して、ユーザーがどの役割を担っているかシンボルで返すメソッド
  def position_in_the_recruiting(recruiting)
    return false unless recruiting

    applicants = recruiting.applicants

    if self.user_id == recruiting.user_id
      :owner
    elsif applicants.include?(self) && self.applicant_entry_recruiting.approved?
      :member
    elsif applicants.include?(self)
      :applicant
    elsif applicants.exclude?(self) && !self.entry_recruiting
      :free
    else
      :applicant_for_another_recruiting
    end
  end

end
