class Jobler::JobsController < Jobler::ApplicationController
  def show
    @job = Jobler::Job.find_by!(slug: params[:id])

    respond_to do |format|
      format.json do
        render json: {
          job: {
            progress: @job.progress,
            state: @job.state,
            state_humanized: @job.state.humanize
          }
        }
      end

      if @job.completed?
        @job.jobler.controller = self
        @job.jobler.format = format

        @result = @job.jobler.result
        format.html { redirect_to @result.url } if @result.is_a?(Jobler::RedirectTo)
      else
        format.html
      end
    end
  end
end
