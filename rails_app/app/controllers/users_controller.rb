class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
  end


  private

  def set_user
    @user = User.find_by!(user_id: params[:user_id])
  end

  def user_params
    params.require(:user).permit(:user_id)
  end

end
