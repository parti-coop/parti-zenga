class Comment < ActiveRecord::Base
  include Statusable
  include RelatedLinkable

  belongs_to :issue
  belongs_to :user
  belongs_to :proposition
  has_many :related_links, as: :source
  has_many :links, through: :related_links

  validates :contents, presence: true

  def linkable_contents
    contents
  end

  def stated_proposition
    proposition
  end
end
