class Status < ActiveRecord::Base
  belongs_to :source, polymorphic: true
  default_scope { order(id: :desc) }

  def contents
    source.contents_as_status
  end

  def user
    source.user
  end
end
