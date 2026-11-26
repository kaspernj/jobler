class AddProgressCountsToJoblerJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobler_jobs, :progress_current_count, :integer, default: 0, null: false
    add_column :jobler_jobs, :progress_total_count, :integer, default: 0, null: false
  end
end
