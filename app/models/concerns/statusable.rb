module Statusable
  extend ActiveSupport::Concern

  included do
    has_one :status, as: :source
    after_create :create_status
  end

  private

  def create_status
    @status = issue.statuses.new
    @status.source = self
    @status.save
  end
end
