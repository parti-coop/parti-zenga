module Statusable
  extend ActiveSupport::Concern

  included do
    has_one :status, as: :source

    attr_accessor :statusable_copied

    after_create :create_status
  end

  def replies
    status.replies
  end

  private

  def create_status
    return if self.statusable_copied
    @status = issue.statuses.new
    @status.source = self
    @status.proposition = self.stated_proposition
    @status.save!
  end
end
