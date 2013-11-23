class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.integer :user_id,         :null => false
      t.integer :pull_request_id, :null => false
      t.date    :date,            :null => false

      t.timestamps
    end

    add_index :gifts, [:user_id, :pull_request_id], :unique => true
  end
end
