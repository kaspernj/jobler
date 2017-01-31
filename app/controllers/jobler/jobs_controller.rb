class Jobler::JobsController < Jobler::ApplicationController
  def show
    @job = Jobler::Job.find(params[:id])
    @result = @job.jobler.result if @job.completed?

    respond_to do |format|
      format.json do
        render json: {
          job: {
            progress: @job.progress,
            state: @job.state
          }
        }
      end
      format.html
    end
  end
end
