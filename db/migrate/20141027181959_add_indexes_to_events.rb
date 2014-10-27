class AddIndexesToEvents < ActiveRecord::Migration
  def change
    add_index :events, :start_time
  end
end
