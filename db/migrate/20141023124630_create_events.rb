class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string :organiser
      t.string :location
      t.string :url
      t.datetime :start_time
      t.decimal :latitude,  precision: 10, scale: 6
      t.decimal :longitude,  precision: 10, scale: 6

      t.timestamps null: false
    end
  end
end
