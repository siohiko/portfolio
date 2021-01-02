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

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :authentication_keys => [:user_id]

  devise :validatable, password_length: 8..128
  validates :user_id, presence: true, uniqueness: true, length: { maximum: 32 }
  validates :name, length: { maximum: 16 }
  validates :introduce, length: { maximum: 255 }


  enum sex: { "男性": 0, "女性": 1}


  #Don't use email. on divise
  def email_required?
    false
  end

  #Don't use email. on divise
  def email_changed?
    false
  end
  
  #monkey patch. Don't use email. on divise
  def will_save_change_to_email?
    false
  end

  # Do not require current password for update
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


  def is_owner?(recruiting)
    return false unless recruiting

    if self.user_id == recruiting.user_id
      true
    else
      false
    end
  end


  def is_applicant?(recruiting)
    return false unless recruiting

    recruiting.applicants.include?(self)
  end


  def is_member?(recruiting)
    return false unless recruiting

    if recruiting.applicants.include?(self) && self.applicant_entry_recruiting.approved?
      true
    else
      false
    end
  end


  def is_free?
    self.entry_recruiting ? false : true
  end

end
