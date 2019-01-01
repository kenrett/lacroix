class CreateAuths < ActiveRecord::Migration[5.2]
  def change
    create_table :auths, primary_key: %i[user_id team_id] do |t|
      t.string :user_id
      t.string :team_id
      t.string :access_token
      t.string :scope
      t.string :bot_user_id
      t.string :bot_access_token

      t.timestamps

      t.index :team_id
    end
  end
end
