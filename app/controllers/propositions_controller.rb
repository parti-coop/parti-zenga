class PropositionsController < ApplicationController
  before_action :authenticate_user!
  before_action :issue

  def new
    @proposition = @issue.propositions.new
  end

  def create
    @proposition = @issue.propositions.new(create_params)
    if @proposition.save
      redirect_to issue
    else
      render 'new'
    end
  end

  private
    def issue
      @issue = Issue.find params[:issue_id]
    end

    def create_params
      params.require(:proposition).permit([:title])
    end
end
