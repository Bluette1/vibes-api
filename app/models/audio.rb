class Audio < ApplicationRecord
  validates :title, presence: true
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }
  validates :duration, numericality: { only_integer: true, greater_than: 0 }
  validates :audio_type, inclusion: { in: ['background music', 'guided session', 'other'] }

  scope :by_audio_type, ->(type) { where(audio_type: type) }
end
