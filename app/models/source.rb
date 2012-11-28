class Source < ActiveRecord::Base
  has_many :articles
  attr_accessible :name, :rss, :url
end
