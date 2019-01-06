class Auth < ApplicationRecord
  self.primary_keys = :user_id, :team_id
end
