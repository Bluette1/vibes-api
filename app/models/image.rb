class Image < ApplicationRecord
  validates :src, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }

  scope :by_category, ->(category) { where(category:) }
end
