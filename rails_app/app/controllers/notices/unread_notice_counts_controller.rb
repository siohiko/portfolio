class Notices::UnreadNoticeCountsController < ApplicationController
  before_action :user_needed,
                :set_user
                
  def show
    unread_notices = Notice.where(user_id: @user.user_id).where(status: 'unread')
    render status: 200, json: { status: 200, unread_count: unread_notices.size }
  end

  private

  def set_user
    @user = current_user
  end

  def user_needed
    unless current_user
      render status: 401, json: {'error' => 'authentication error'}
    end
  end
end