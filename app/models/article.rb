class Article < ApplicationRecord
  validates_presence_of :title, :description, :url, :url_to_image, :published_at
  validates_uniqueness_of :title
end
