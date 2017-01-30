class CreateJoblers < ActiveRecord::Migration
  def change
    create_table :joblers do |t|
      t.string :jobler_type
      t.text :parameters
      t.datetime :started_at
      t.datetime :completed_at
      t.timestamps null: false
    end
  end
end
