module NoticeFactory
  extend ActiveSupport::Concern

  def create_application_notice(owner_id:, applicant_id:, recruiting_id:, content:)
    notice = ApplicationNotice.new(
        type: 'ApplicationNotice',
        title: '参加申請のお知らせ',
        user_id: owner_id,
        applicant_id: applicant_id,
        recruiting_id: recruiting_id,
        content: content
      )

    if notice.save
      return true
    else
      return false
    end
  end


  def create_adoption_notice(applicant_id:, recruiting_id:)
    notice = AdoptionNotice.new(
        type: 'AdoptionNotice',
        title: '参加申請が承認のお知らせ',
        user_id: applicant_id,
        recruiting_id: recruiting_id
      )

    if notice.save
      return true
    else
      return false
    end
  end
end