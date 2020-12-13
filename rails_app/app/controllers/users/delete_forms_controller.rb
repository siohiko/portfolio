class Users::DeleteFormsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user


  def new
  end

  private

  def set_user
    @user = current_user
  end

end
