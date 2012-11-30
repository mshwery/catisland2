class Article < ActiveRecord::Base
  include ActionView::Helpers
  require 'nokogiri'
  require 'open-uri'  

  belongs_to :source
  attr_accessible :edited_body, :original_html, :source_id, :title, :original_url, :published_at

  scope :sorted, :order => 'published_at DESC'
  scope :recent, lambda { where("published_at > ?", 2.day.ago) }

  self.per_page = 20

  def summary
    truncate(strip_tags(sanitized), length: 400, separator: ' ', omission: ' ... ')
  end

  def summary_image_tag
    doc = Nokogiri::HTML(edited_body)
    image = doc.xpath("/html/body//img[@src[contains(.,'://') and not(contains(.,'ads.') or contains(.,'ad.') or contains(.,'?'))]][1]").first.to_s
    sanitize(image)
  end

  def summary_img
    doc = Nokogiri::HTML(edited_body)
    image = doc.xpath("/html/body//img[@src[contains(.,'://') and not(contains(.,'ads.') or contains(.,'ad.') or contains(.,'?'))]][1]").first
    image['src'].to_s if image
  end

  def sanitized
    sanitize(body.strip, attributes: %w(style src href))
  end

  def body
    edited_body || original_html
  end

end
