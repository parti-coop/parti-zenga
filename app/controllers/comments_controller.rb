class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :issue

  def create
    @comment = @issue.comments.new(create_params)
    @comment.user = current_user
    unless @comment.save
      flash[:error] = t('application.error')
    end
    redirect_to @issue
  end

  private

  def issue
    @issue = Issue.find params[:issue_id]
  end

  def create_params
    params.require(:comment).permit([:contents])
  end
end
