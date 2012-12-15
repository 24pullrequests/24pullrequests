class CreateDataClipsTable < ActiveRecord::Migration
  def change
    create_table :data_clips do |t|
      t.string :title
      t.string :url
      t.text :json
      t.string :chart_type
      t.timestamps
    end    
  end
end