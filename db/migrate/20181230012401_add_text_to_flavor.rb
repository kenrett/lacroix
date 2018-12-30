class AddTextToFlavor < ActiveRecord::Migration[5.2]
  def change
    add_column :flavors, :text, :string
  end
end
