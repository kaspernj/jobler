class AddLocaleToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobler_jobs, :locale, :string
  end
end
