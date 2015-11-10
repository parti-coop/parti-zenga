module RelatedLinkable
  extend ActiveSupport::Concern

  included do
    has_many :related_links, as: :source
    has_many :links, through: :related_links

    attr_accessor :related_linkable_copied

    before_create :new_related_links
  end

  def replies
    status.replies
  end

  def stated_links
    links
  end

  def remap_related_links_after_fork
    self.related_linkable_copied = true
    copy_related_links = []
    self.related_links.each do |original_related_link|
      copy_related_link = original_related_link.amoeba_dup
      copy_related_link.remap_after_fork self
      copy_related_links << copy_related_link
    end
    self.related_links.clear
    self.related_links = copy_related_links
  end

  private

  def new_related_links
    return if self.related_linkable_copied
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
        proposition: self.try(:proposition),
        source: self,
        link: link)
      url_text
    end
  end
end
