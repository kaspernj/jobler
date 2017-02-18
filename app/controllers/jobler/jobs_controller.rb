class Jobler::JobsController < Jobler::ApplicationController
  def show
    @job = Jobler::Job.find_by!(slug: params[:id])
    @result = @job.jobler.result if @job.completed?

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

      if @result.is_a?(Jobler::RedirectTo)
        format.html { redirect_to @result.url }
      else
        format.html
      end
    end
  end
end
