class StandsController < ApplicationController
  before_action :authenticate_user!
  before_action :issue
  before_action :proposition

  def new
    @stand = @proposition.stands.new
  end

  def create
    previous_stand = @proposition.stand current_user

    @stand = @proposition.stands.new(create_params)
    @stand.user = current_user
    @stand.previous = previous_stand

    if @stand.save
      redirect_to @issue
    else
      render 'new'
    end
  end

  private

  def issue
    @issue ||= proposition.issue
  end

  def proposition
    @proposition ||= Proposition.find params[:proposition_id]
  end

  def create_params
    params.require(:stand).permit([:choice])
  end
end
