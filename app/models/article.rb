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

  def sanitized
    sanitize(body.strip, attributes: %w(style src href))
  end

  def body
    edited_body || original_html
  end

end
