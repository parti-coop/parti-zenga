class IssuesController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @issues = Issue.all
  end

  def show
    @issue = Issue.find params[:id]
    @statuses = @issue.statuses.all
    @new_comment = @issue.comments.new
  end

  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new(create_params)
    if @issue.save
      redirect_to @issue
    else
      render 'new'
    end
  end

  private

  def create_params
    params.require(:issue).permit([:title])
  end
end
