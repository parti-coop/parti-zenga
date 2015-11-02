class StandsController < ApplicationController
  include Commenting

  before_action :authenticate_user!
  before_action :issue
  before_action :proposition
  before_action :prepare_commenting, only: :create

  def new
    new_stand
    new_comment
  end

  def create
    unless has_stand_params?
      new_stand
      new_comment
      render 'new'
      return
    end

    previous_stand = @proposition.stand current_user

    @stand = @proposition.stands.new(create_params)
    @stand.user = current_user
    @stand.previous = previous_stand

    if @stand.save
      create_comment if params[:has_comment]
      redirect_to @issue
    else
      new_comment
      render 'new'
    end
  end

  private

  def has_stand_params?
    params[:stand].present?
  end

  def issue
    @issue ||= proposition.issue
  end

  def proposition
    @proposition ||= Proposition.find params[:proposition_id]
  end

  def create_params
    params.require(:stand).permit([:choice])
  end

  def new_comment
    @comment = @issue.comments.new
  end

  def new_stand
    @stand = @proposition.stands.new
  end
end
