class JoblerJobsController < ApplicationController
  def show
    @job = Jobler::Job.find_by!(slug: params[:id])
    @result = @job.results.find_by!(name: "render")
  end
end
