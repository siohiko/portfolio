class ApexProfilesController < ApplicationController
  before_action :authenticate_user!, :set_user
  before_action :set_apex_profile, only: [:edit, :update, :destroy]

  def new
    if @user.apex_profile
      redirect_to edit_apex_profile_path
    else
      @apex_profile = ApexProfile.new
    end
  end


  def create 
    @apex_profile = @user.build_apex_profile(apex_profile_params)

    if @apex_profile.save
      redirect_to user_path(@user.user_id)
    else
      render 'new'
    end

  end


  def edit
  end


  def update

    if @apex_profile.update(apex_profile_params)
      redirect_to user_path(@user.user_id)
    else
      render 'edit'
    end

  end


  def destroy
    @apex_profile.destroy
    redirect_to user_path(@user.user_id)
  end



  private

  def apex_profile_params
    params.require(:apex_profile).permit(:apex_id, :rank, :level, :platform, { :legend_ids => [], :weapon_ids => [] })
  end

  def set_user
    @user = current_user
  end

  def set_apex_profile
    @apex_profile = @user.apex_profile
    return redirect_to new_apex_profile_path if @apex_profile.nil?
  end
end
