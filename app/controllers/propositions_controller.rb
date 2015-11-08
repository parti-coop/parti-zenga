class PropositionsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :issue, only: [:new, :create]

  def show
    @proposition = Proposition.find params[:id]
    @issue = @proposition.issue
    @new_comment = @issue.comments.new
    @statuses = @proposition.statuses
  end

  def new
    @proposition = @issue.propositions.new
  end

  def create
    @proposition = @issue.propositions.new(create_params)
    @proposition.user = current_user
    if @proposition.save
      redirect_to @issue
    else
      render 'new'
    end
  end

  private

  def issue
    @issue ||= Issue.find params[:issue_id]
  end

  def create_params
    params.require(:proposition).permit([:title])
  end
end
