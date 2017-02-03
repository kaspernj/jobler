class AddLocaleToJobs < ActiveRecord::Migration
  def change
    add_column :jobler_jobs, :locale, :string
  end
end
