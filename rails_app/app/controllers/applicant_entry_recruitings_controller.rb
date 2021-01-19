class ApplicantEntryRecruitingsController < ApplicationController
  before_action :authenticate_user!, :set_user
  before_action :set_recruiting, only: [:index, :update, :destroy]
  before_action :is_user_owner?, only: [:index, :update]
  before_action :set_user_for_destroy, only: [:destroy]

  #参加メンバーと、応募者両方のリストを返す。
  def index
    participants = []
    applicants = []
    @recruiting.applicants.includes(:applicant_entry_recruiting).each do |applicant|
      if applicant.applicant_entry_recruiting.approved?
        participants << applicant 
      else
        applicants << applicant 
      end
    end

    response_data = {
      participants: participants,
      applicants: applicants
    }

    render :json => response_data
  end


  def create
    recruiting_id = applicant_entry_recruiting_params[:recruiting_id]
    recruiting = Recruiting.find_by(id: recruiting_id)

    entry = ApplicantEntryRecruiting.new(
      applicant_id: @user.user_id,
      entry_recruiting_id: recruiting_id,
      message: applicant_entry_recruiting_params[:message]
    )

    if entry.save
      response_created
    else 
      response_conflict('ApplicantEntryRecruiting', entry.errors)
    end
  end


  def update
    entry = ApplicantEntryRecruiting.find_by(applicant_id: applicant_entry_recruiting_params[:applicant_id])

    if entry.update(status: applicant_entry_recruiting_params[:status])
      response_created
    else
      response_conflict('ApplicantEntryRecruiting', entry.errors)
    end

  end


  def destroy

    entry = ApplicantEntryRecruiting.where(
      entry_recruiting_id: applicant_entry_recruiting_params[:recruiting_id]
    ).where(
      applicant_id: @tagret_user.user_id
    )


    if entry[0]

      #エントリー削除理由が送信されていれば、インスタンスにセット
      delete_reason = applicant_entry_recruiting_params[:delete_reason]
      entry[0].delete_reason = delete_reason if delete_reason

      entry[0].destroy
      response_success
    else
      response_bad_request
    end
  end



  private

  def applicant_entry_recruiting_params
    params.require(:applicant_entry_recruiting).permit(:recruiting_id, :applicant_id, :status, :message, :delete_reason)
  end


  def set_user
    @user = current_user
  end


  def set_recruiting
    @recruiting = Recruiting.find_by(id: applicant_entry_recruiting_params[:recruiting_id])
  end


  #ユーザーがオーナーかどうか確認する
  def is_user_owner?
    if @recruiting
      @recruiting.owner?(current_user) ? true : response_unauthorized
    else
      response_unauthorized
    end
  end


  #ユーザーがオーナーの時はパラメータよりユーザーをセット、それ以外の場合はアクセスしたユーザー本人をセット。
  def set_user_for_destroy
    return response_unauthorized unless @recruiting

    if @recruiting.owner?(current_user)
      @tagret_user = User.find_by(user_id: applicant_entry_recruiting_params[:applicant_id])
    else
      @tagret_user = current_user
    end

    return response_unauthorized unless @tagret_user
  end

end