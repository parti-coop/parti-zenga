class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :issue
  before_action :proposition

  def create
    @comment = @issue.comments.new(create_params)
    @comment.user = current_user
    @comment.proposition = @proposition
    unless @comment.save
      flash[:error] = t('application.error')
    end

    redirect_to @issue
  end

  private

  def issue
    @issue = Issue.find params[:issue_id]
  end

  def proposition
    proposition_id =  params[:comment][:proposition_id]
    @proposition = Proposition.find proposition_id if proposition_id.present?
  end

  def create_params
    params.require(:comment).permit([:contents, :proposition_id])
  end
end
