class AddHostProtocolAndPortToJoblerJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobler_jobs, :host, :string
    add_column :jobler_jobs, :protocol, :string
    add_column :jobler_jobs, :port, :integer
  end
end
