module RelatedLinkable
  extend ActiveSupport::Concern

  included do
    has_many :related_links, as: :source
    has_many :links, through: :related_links
    before_create :new_related_links
  end

  def replies
    status.replies
  end

  private

  def new_related_links
    ApplicationController.helpers.auto_link(linkable_contents, :urls) do |url_text|
      link = Link.find_by url: url_text
      if link.nil?
        og = LinkThumbnailer.generate(url_text)
        link = Link.new(
          url: url_text,
          title: og.title,
          description: og.description,
          image: og.images.first.src.to_s)
      end
      related_links.new(
        issue: issue,
        source: self,
        link: link)
      url_text
    end
  end
end
