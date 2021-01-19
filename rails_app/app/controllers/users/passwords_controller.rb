class Users::PasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user


  def edit
  end


  def update
    if @user.update_with_password(user_password_params)
      bypass_sign_in(current_user)
      redirect_to user_path(current_user.user_id)
    else
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_password_params
    params.require(:user_password).permit(:password, :password_confirmation, :current_password)
  end

end
