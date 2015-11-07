class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_issue
  before_action :set_proposition

  def create
    @comment = @issue.comments.new(create_params)
    @comment.user = current_user
    @comment.proposition = @proposition

    unless @comment.save
      flash[:error] = t('application.error')
    end

    redirect_to @issue
  end

  def new
    @comment = @issue.comments.new
    respond_to do |format|
      format.js
    end
  end

  private

  def set_issue
    @issue = Issue.find params[:issue_id]
  end

  def set_proposition
    proposition_id = params[:comment].present? ? params[:comment][:proposition_id] : params[:proposition_id]
    @proposition = Proposition.find proposition_id if proposition_id.present?
  end

  def create_params
    params.require(:comment).permit([:contents])
  end
end
