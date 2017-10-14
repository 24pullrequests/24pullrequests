class AddIndexesToEvents < ActiveRecord::Migration[4.2]
  def change
    add_index :events, :start_time
  end
end
