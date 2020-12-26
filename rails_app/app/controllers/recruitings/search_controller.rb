class Recruitings::SearchController < ApplicationController
  before_action :authenticate_user!, :set_user, :set_users_recruiting


  # ApexRecruiting only for now.
  def show

    if search_params.present?
      search_results = Recruiting.search(search_params)
    else
      search_results = Recruiting.all
    end

    @search_results_for_view = search_results.page(params[:page]).per(5)

    if search_results
      @search_results_count = search_results.size
    else
      @search_results_count = 0
    end

    
  end


  private

  def search_params
    params.permit(:commit, search: [:type, :rank, :game_mode])
  end

  def set_user
    @user = current_user
  end

  def set_users_recruiting
    @recruiting = @user.recruiting
  end


end