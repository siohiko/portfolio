class RecruitingsController < ApplicationController
  #typeパラメーターが不適切だった場合のエラーハンドリング
  rescue_from ActiveRecord::SubclassNotFound, with: :subclass_not_found

  before_action :authenticate_user!, :set_user
  before_action :set_users_recruiting, except: [:create, :show, :search]
  before_action :set_recruiting, only: [:show]


  def new
    if @recruiting
      redirect_to edit_recruiting_path(@recruiting.id)
    else
      @recruiting = Recruiting.new
    end
  end


  def create
    @recruiting = @user.build_recruiting(recruiting_params)

    if @recruiting.save
      redirect_to recruiting_path(@recruiting)
    else
      render 'new'
    end
  end


  def edit
    if @recruiting.nil?
      redirect_to new_recruiting_path
    end
  end


  def update
    return redirect_to new_recruiting_path if @recruiting.nil?

    if @recruiting.update(recruiting_params)
      redirect_to recruiting_path(@recruiting)
    else
      render 'edit'
    end
  end


  def destroy
    @recruiting.destroy
    redirect_to user_path(@user.user_id)
  end


  def show
    @user_position_for_recruiting = @user.position_in_the_recruiting(@recruiting)
    @comments = @recruiting.comments.page(params[:page]).per(15)
  end





  private

  def recruiting_params
    params.require(:recruiting).permit(:type, :vc, :recruitment_numbers, :play_style, :comment, :rank, :game_mode, :status)
  end


  def search_params
    params.permit(:commit, search: [:type, :rank, :game_mode])
  end


  def set_user
    @user = current_user
  end


  def set_recruiting
    @recruiting = Recruiting.find_by(id: params[:id])
    redirect_to root_path unless @recruiting
  end


  def set_users_recruiting
    @recruiting = @user.recruiting
  end

  #typeパラメータが不適切な場合のエラー処理。この場合、正規フォームからのリクエストでない可能性が高いので、ルートにリダイレクト
  def subclass_not_found(action)
    redirect_to root_path
  end

end
