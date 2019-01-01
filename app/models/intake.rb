class Intake < ApplicationRecord
  # TODO scope by user... oops
  scope :this_week, -> { where('created_at >= ?', 1.week.ago) }
  scope :today, -> { where('created_at > ?', 1.day.ago)}
  scope :by_flavor, ->(flavor) { where('flavor_id = ?', flavor) }
end
