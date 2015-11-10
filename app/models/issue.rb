class Issue < ActiveRecord::Base
  has_many :statuses
  has_many :propositions
  has_many :comments
  belongs_to :user
  belongs_to :parent_issue, class_name: Issue
  belongs_to :related_proposition, class_name: Proposition
  has_many :related_links
  has_many :links, ->{ distinct }, through: :related_links

  default_scope { order(id: :desc) }

  amoeba do
    include_association [:propositions, :comments]
    customize(lambda { |original, copy|
      copy.created_at = original.created_at
    })
  end

  def related_issue
    related_proposition.try(:issue)
  end

  def max_stands_count_in_propositions
    propositions.maximum(:stands_count)
  end

  def fork
    self.amoeba_dup.remap_after_fork self
  end

  def forked?
    self.parent_issue.present?
  end

  def remap_after_fork original
    self.propositions.each do |proposition|
      proposition.remap_after_fork
    end

    self.comments.each do |comments|
      comments.remap_after_fork original
    end

    self
  end

end
