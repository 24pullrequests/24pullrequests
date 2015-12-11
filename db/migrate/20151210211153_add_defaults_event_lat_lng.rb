class AddDefaultsEventLatLng < ActiveRecord::Migration
  def up
    change_column_default :events, :latitude, 0.0
    change_column_default :events, :longitude, 0.0
  end

  def down
    change_column_default :events, :latitude, nil
    change_column_default :events, :longitude, nil
  end
end
