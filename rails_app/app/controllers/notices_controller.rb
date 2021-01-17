class NoticesController < ApplicationController
  before_action :authenticate_user!, :set_user, :set_notices
  after_action :update_notice_status, only: :index

  def index

    #未読件数をカウント
    @unread_count = 0
    @notices.each do |notice|
      @unread_count += 1 if notice.unread?
    end

    @notices = @notices.page(params[:page]).per(10)

  end


  private

  def set_user
    @user = current_user
  end

  def set_notices
    @notices = @user.notices
  end

  #@noticesはページネーションによって、最高10件までしかないので、既読だろうが未読だろうが、update_allで一括更新して既読にする。
  def update_notice_status
    @notices.update_all(status: 'read')
  end

end
