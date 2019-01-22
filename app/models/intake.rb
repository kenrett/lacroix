class Intake < ApplicationRecord
  scope :this_week, -> { where('created_at >= ?', 1.week.ago) }
  scope :today, -> { where('created_at > ?',  Time.zone.now.beginning_of_day) }
  scope :by_flavor, ->(flavor) { where('flavor_id = ?', flavor) }
end
