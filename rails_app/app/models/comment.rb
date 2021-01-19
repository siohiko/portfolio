class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :recruiting

  default_scope -> { order(created_at: :desc) }

  validate :valid_authenticated_user?

  private

  #ユーザーが募集オブジェクトのメンバー、オーナーでなければ作成できない
  def valid_authenticated_user?
    if recruiting && user
      user_position = user.position_in_the_recruiting(recruiting)

      unless user_position === :owner || user_position === :member
        errors.add(:authority, 'コメント投稿の権限がありません')
      end
    end
  end

end
