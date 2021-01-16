# == Schema Information
#
# Table name: notices
#
#  id            :bigint           not null, primary key
#  content       :text
#  status        :integer          default("未読"), not null
#  title         :string
#  type          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  applicant_id  :string
#  recruiting_id :integer
#  user_id       :string
#
# Indexes
#
#  index_notices_on_user_id  (user_id)
#
class DeleteEntryNotice < Notice
  validates :reason_for_delete_entry,  presence: true

  #reason_for_delete_entryのデフォルト値になる「discard」はエントリーレコード削除理由が不明な時用に用いる。
  enum reason_for_delete_entry: { 
    'discard':0,
    'refusal': 1,
    'decline': 2,
    'kick': 3
  }


  class << self

    def create_for_reason(owner_id:, applicant_id:, recruiting_id:, reason:)

      #エントリー削除理由に従って通知先を設定
      if reason == 'refusal' || reason == 'kick'
        destination = applicant_id
      elsif reason == 'decline'
        destination = owner_id
      else
        return nil
      end

      notice = self.new(
        type: 'DeleteEntryNotice',
        title: set_title(reason.to_sym),
        user_id: destination,
        recruiting_id: recruiting_id,
        applicant_id: applicant_id,
        reason_for_delete_entry: reason
      )

      if notice.save
        return notice 
      else 
        return false
      end
    end


    private 

    #エントリー削除理由に従ってタイトルを返す
    def set_title(reason_sym)
      return nil unless reason_sym.is_a?(Symbol)

      titles_hash = {
        discard: '不明',
        refusal: '参加申請が拒否されました',
        decline: '参加メンバーが離脱しました',
        kick: 'キックされました'
      }

      return titles_hash[reason_sym]
    end

  end

  

end
