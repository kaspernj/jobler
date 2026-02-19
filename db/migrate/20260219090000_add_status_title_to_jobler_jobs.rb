class AddStatusTitleToJoblerJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobler_jobs, :status_title, :string
  end
end
