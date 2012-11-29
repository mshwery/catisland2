class Article < ActiveRecord::Base
  include ActionView::Helpers
  require 'open-uri'

  belongs_to :source
  attr_accessible :body, :original_html, :source_id, :title, :original_url, :published_at

  after_commit :fetch_full_article
  after_commit :format_content

  scope :sorted, :order => 'published_at DESC'

  def summary
    truncate(strip_tags(sanitized), length: 400, separator: ' ', omission: '...')
  end

  def sanitized
    sanitize(body, attributes: %w(style src href))
  end

  private

  def fetch_full_article
    full_article = Nokogiri::HTML(open(original_url))
  end

  def format_content
    doc = Nokogiri::HTML(original_html)
    formatted_content = strip_source_links(doc)
    body = strip_social_media(formatted_content)

    save
  end

  def strip_source_links(content)
    content.search('a.excerpt-more').each do |link|
      link.remove if link[:href] == self.original_url # Nola Defender
    end

    content
  end

  def strip_social_media(content)
    content.search('div.sociable').remove # Uptown Messenger

    content
  end

end
