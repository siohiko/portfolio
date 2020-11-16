class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :authentication_keys => [:user_id]

  validates :user_id, presence: true



  #deviseにてemailを使用しないようにメソッドをオーバーライド
  def email_required?
    false
  end

  def email_changed?
    false
  end
  
  #deviseでemailを使わない時に下記メソッドでエラーが起きる。その修正がされるまでのモンキーパッチ
  def will_save_change_to_email?
    false
  end
end
