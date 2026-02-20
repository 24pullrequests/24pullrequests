class CreateContributionTimestampNormalizations < ActiveRecord::Migration[7.1]
  def change
    create_table :contribution_timestamp_normalizations do |t|
      t.references :contribution, null: false, foreign_key: { on_delete: :cascade }, index: { unique: true }
      t.datetime :original_created_at, null: false
      t.datetime :normalized_created_at, null: false
      t.string :applied_timezone, null: false
      t.datetime :normalized_at, null: false

      t.timestamps null: false
    end
  end
end
