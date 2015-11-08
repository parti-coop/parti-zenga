class Status < ActiveRecord::Base
  belongs_to :source, polymorphic: true
  belongs_to :issue
  belongs_to :proposition, class_name: Proposition, foreign_key: :proposition_id
  has_many :replies

  default_scope { order(updated_at: :desc).order(id: :desc) }

  def contents
    source.contents_as_status
  end

  def user
    source.user
  end
end
