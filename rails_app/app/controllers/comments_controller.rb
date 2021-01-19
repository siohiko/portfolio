class CommentsController < ApplicationController
  before_action :authenticate_user!, :set_user

  def create
    comment = Comment.new(
      content: comment_params[:comment],
      recruiting_id: comment_params[:recruiting_id],
      user_id: @user.user_id,
    )

    if comment.save
      response_created
    else
      response_conflict(Comment, comment.errors)
    end

  end


  private

  def comment_params
    params.require(:comment).permit(:content, :recruiting_id)
  end

  def set_user
    @user = current_user
  end

end