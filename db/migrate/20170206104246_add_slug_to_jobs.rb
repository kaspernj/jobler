class AddSlugToJobs < ActiveRecord::Migration
  def change
    add_column :jobler_jobs, :slug, :string
    add_index :jobler_jobs, :slug, unique: true
  end
end
