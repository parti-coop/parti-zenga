class CommentsController < ApplicationController
  include Commenting
  before_action :prepare_commenting, only: :create

  def create
    create_comment
    redirect_to @issue
  end

  def new
    @comment = issue.comments.new
    @proposition = Proposition.find params[:proposition_id] if params[:proposition_id].present?
    respond_to do |format|
      format.js
    end
  end

  private

  def issue
    Issue.find params[:issue_id]
  end
end
