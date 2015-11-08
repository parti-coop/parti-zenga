class Reply < ActiveRecord::Base
  include RelatedLinkable

  belongs_to :status
  belongs_to :user

  validates :contents, presence: true
  after_create :touch_status

  def linkable_contents
    contents
  end

  def issue
    status.issue
  end

  def proposition
    status.proposition
  end

  private

  def touch_status
    status.touch
    status.save!
  end
end
