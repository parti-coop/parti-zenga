class RepliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_status

  def create
    @reply = @status.replies.new(create_params)
    @reply.user = current_user
    unless @reply.save
      flash[:error] = t('application.error')
    end

    redirect_to @status.issue
  end

  private

  def set_status
    @status = Status.find params[:status_id]
  end

  def create_params
    params.require(:reply).permit([:contents])
  end
end
