class ChangeDescriptionFromStringToTextInEvents < ActiveRecord::Migration[4.2]
  def change
    change_column :events, :description, :text
  end
end
