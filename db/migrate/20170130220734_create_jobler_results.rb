class CreateJoblerResults < ActiveRecord::Migration
  def change
    create_table :jobler_results do |t|
      t.belongs_to :jobler, index: true, null: false, foreign_key: true
      t.binary :result, limit: 16.megabyte
      t.timestamps null: false
    end
  end
end
