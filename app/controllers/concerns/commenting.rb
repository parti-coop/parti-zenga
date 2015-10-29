module Commenting
  extend ActiveSupport::Concern

  included do
    attr_reader :issue, :proposition
    before_action :authenticate_user!
    before_action :prepare_commenting
  end

  def create_comment
    return unless has_comment_params?

    @comment = @issue.comments.new(create_comment_params)
    @comment.user = current_user
    @comment.proposition = @proposition
    unless @comment.save
      flash[:error] = t('application.error')
    end
  end

  private

  def has_comment_params?
    params[:comment].present?
  end

  def prepare_commenting
    @issue ||= issue

    if has_comment_params?
      proposition_id =  params[:comment][:proposition_id]
      @proposition ||= Proposition.find proposition_id if proposition_id.present?
    end
  end

  def create_comment_params
    params.require(:comment).permit([:contents, :proposition_id])
  end
end
