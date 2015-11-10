class RelatedLink < ActiveRecord::Base
  belongs_to :source, polymorphic: true
  belongs_to :link
  belongs_to :issue
  belongs_to :proposition

  def remap_after_fork source
    self.source = source
    self.issue = source.issue
    self.proposition = source.proposition
  end
end
