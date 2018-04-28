class CreateJoblerResults < ActiveRecord::Migration[5.1]
  def change
    create_table :jobler_results do |t|
      t.belongs_to :job, index: true, null: false
      t.string :name, index: true, null: false
      t.binary :result, limit: 16.megabyte
      t.timestamps null: false
    end

    add_foreign_key :jobler_results, :jobler_jobs, column: "job_id"
  end
end
