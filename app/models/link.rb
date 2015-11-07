class Link < ActiveRecord::Base
  has_many :related_links

  validates :url, presence: true, uniqueness: true

  def title_or_url
    title || url
  end

  def has_meta?
    title.present? || image.present?
  end
end
