class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, :authentication_keys => [:user_id]

  devise :validatable, password_length: 8..128
  validates :user_id, presence: true



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
end
