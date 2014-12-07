class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :organiser
      t.string :location
      t.string :url
      t.datetime :start_time
      t.decimal :latitude,  precision: 10, scale: 6
      t.decimal :longitude,  precision: 10, scale: 6

      t.timestamps
    end
  end
end
