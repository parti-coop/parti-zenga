module Commenting
  extend ActiveSupport::Concern

  included do
    attr_reader :issue, :proposition, :prepared_commenting
  end

  def prepare_commenting
    authenticate_user!

    @issue ||= Issue.find params[:issue_id]

    if has_comment_params?
      proposition_id =  params[:comment][:proposition_id]
      @proposition ||= Proposition.find proposition_id if proposition_id.present?
    end

    @prepared_commenting = true
  end

  def create_comment
    raise "Please call 'Commenting::prepare_commenting' before creating a comment" unless @prepared_commenting

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

  def create_comment_params
    params.require(:comment).permit([:contents])
  end
end
