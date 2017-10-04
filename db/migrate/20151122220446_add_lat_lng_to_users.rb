class AddLatLngToUsers < ActiveRecord::Migration[4.2]
  # Adds geolocation lat/lng to users based on their public GH location
  def change
    add_column :users, :lat, :decimal, precision: 8, scale: 6
    add_column :users, :lng, :decimal, precision: 9, scale: 6
  end
end
