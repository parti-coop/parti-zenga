class Comment < ActiveRecord::Base
  include Statusable
  include RelatedLinkable

  belongs_to :issue
  belongs_to :user
  belongs_to :proposition
  has_many :related_links, as: :source
  has_many :links, through: :related_links

  validates :contents, presence: true

  amoeba do
    include_association [:proposition, :related_links]
    customize(lambda { |original, copy|
      copy.created_at = original.created_at
      copy.updated_at = original.updated_at
      copy.status = original.status.amoeba_dup
    })
  end

  def linkable_contents
    contents
  end

  def stated_proposition
    proposition
  end

  def remap_after_fork(original_issue)
    self.statusable_copied = true

    unless proposition.nil?
      index = original_issue.propositions.index(proposition)
      self.proposition = self.issue.propositions[index] unless index.nil?
    end

    self.status.remap_after_fork self
    remap_related_links_after_fork
  end
end
