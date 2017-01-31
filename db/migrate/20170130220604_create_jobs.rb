class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobler_jobs do |t|
      t.string :jobler_type, null: false
      t.string :state, default: "new", null: false
      t.float :progress, default: 0.0, null: false
      t.text :parameters
      t.datetime :started_at
      t.datetime :ended_at
      t.timestamps null: false
    end
  end
end
