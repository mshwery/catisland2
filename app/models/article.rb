class Article < ActiveRecord::Base
  belongs_to :source
  attr_accessible :body, :raw, :source_id, :title
end
