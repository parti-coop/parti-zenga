class CommentsController < ApplicationController
  include Commenting

  def create
    create_comment
    redirect_to @issue
  end

  private

  def issue
    Issue.find params[:issue_id]
  end
end
