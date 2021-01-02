class ApplicantEntryRecruitingsController < ApplicationController
  before_action :authenticate_user!, :set_user
  before_action :set_recruiting, :is_updater_owner?, only: [:update]

  def create
    entry = ApplicantEntryRecruiting.new(
      applicant_id: @user.user_id,
      entry_recruiting_id: applicant_entry_recruiting_params[:recruiting_id]
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
      applicant_id: @user.user_id
    )

    if entry[0]
      entry[0].destroy
      response_success
    else
      response_bad_request
    end
  end



  private

  def applicant_entry_recruiting_params
    params.require(:applicant_entry_recruiting).permit(:recruiting_id, :applicant_id, :status)
  end

  def set_user
    @user = current_user
  end

  def set_recruiting
    @recruiting = Recruiting.find_by(id: applicant_entry_recruiting_params[:recruiting_id])
  end

  def is_updater_owner?
    if @recruiting
      @recruiting.owner?(current_user) ? true : response_unauthorized
    else
      response_unauthorized
    end
  end

end