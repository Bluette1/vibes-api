class UserPreference < ApplicationRecord
  belongs_to :user

  # Default values
  after_initialize :set_defaults, if: :new_record?

  private

  def set_defaults
    self.volume ||= 0.5
    self.selected_track ||= ''
    self.image_transition_interval ||= 10_000
  end
end
