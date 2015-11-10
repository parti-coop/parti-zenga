class Status < ActiveRecord::Base
  belongs_to :source, polymorphic: true
  belongs_to :issue
  belongs_to :proposition, class_name: Proposition, foreign_key: :proposition_id
  has_many :replies

  default_scope { order(updated_at: :desc).order(id: :desc) }

  amoeba do
    include_association :replies
    customize(lambda { |original, copy|
      copy.created_at = original.created_at
      copy.updated_at = original.updated_at
    })
  end

  def contents
    source.contents_as_status
  end

  def user
    source.user
  end

  def remap_after_fork source
    self.source = source
    self.issue = source.issue
    self.proposition = source.stated_proposition

    self.replies.each do |reply|
      reply.remap_after_fork
    end
  end
end
