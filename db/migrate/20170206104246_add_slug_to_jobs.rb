class AddSlugToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobler_jobs, :slug, :string
    add_index :jobler_jobs, :slug, unique: true
  end
end
