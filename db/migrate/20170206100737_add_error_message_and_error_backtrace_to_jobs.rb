class AddErrorMessageAndErrorBacktraceToJobs < ActiveRecord::Migration
  def change
    add_column :jobler_jobs, :error_message, :text
    add_column :jobler_jobs, :error_type, :string
    add_column :jobler_jobs, :error_backtrace, :text
  end
end
