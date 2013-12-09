class CreateProjectLabels < ActiveRecord::Migration
  def change
    create_table :project_labels do |t|
      t.references :project, index: true
      t.references :label, index: true

      t.timestamps
    end
  end
end
