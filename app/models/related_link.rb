class RelatedLink < ActiveRecord::Base
  belongs_to :source, polymorphic: true
  belongs_to :link
  belongs_to :issue
  belongs_to :proposition
end
