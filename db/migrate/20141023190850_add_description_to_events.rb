class AddDescriptionToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :description, :string
  end
end
