class CreateProjectLabels < ActiveRecord::Migration[4.2]
  def change
    create_table :project_labels do |t|
      t.references :project, index: true
      t.references :label, index: true

      t.timestamps null: false
    end
  end
end
