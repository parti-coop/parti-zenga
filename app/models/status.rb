class Status < ActiveRecord::Base
  belongs_to :source, polymorphic: true

  def contents
    source.contents_as_status
  end

  def user
    source.user
  end
end
