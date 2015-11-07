class Reply < ActiveRecord::Base
  include RelatedLinkable

  belongs_to :status
  belongs_to :user

  validates :contents, presence: true

  def linkable_contents
    contents
  end

  def issue
    status.issue
  end
end
