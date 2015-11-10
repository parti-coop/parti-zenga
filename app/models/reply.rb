class Reply < ActiveRecord::Base
  include RelatedLinkable

  attr_accessor :copied
  belongs_to :status
  belongs_to :user

  validates :contents, presence: true
  after_create :touch_status

  amoeba do
    include_association [:related_links]
    customize(lambda { |original, copy|
      copy.created_at = original.created_at
      copy.updated_at = original.updated_at
    })
  end

  def linkable_contents
    contents
  end

  def issue
    status.issue
  end

  def proposition
    status.proposition
  end

  def remap_after_fork
    self.copied = true
    remap_related_links_after_fork
  end

  private

  def touch_status
    return if self.copied

    self.status.touch
    self.status.save!
  end

end
