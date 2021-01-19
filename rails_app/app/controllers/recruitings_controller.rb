class RecruitingsController < ApplicationController
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
    # if type is invalid, render new
    if Recruiting::GAMETYPENAMES.exclude?(recruiting_params[:type])
      @recruiting = Recruiting.new
      @recruiting.errors.add(:type, "：指定のゲームは募集できません")
      return render 'new'
    end

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


    # if type is invalid, render new
    if Recruiting::GAMETYPENAMES.exclude?(recruiting_params[:type])
      @recruiting.errors.add(:type, "：指定のゲームは募集できません")
      return render 'new'
    end


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

end
