class CreateIntakes < ActiveRecord::Migration[5.2]
  def change
    create_table :intakes do |t|
      t.string :user_id
      t.integer :flavor_id

      t.timestamps
    end
  end
end
