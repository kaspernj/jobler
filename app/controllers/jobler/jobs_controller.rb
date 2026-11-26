class Jobler::JobsController < Jobler::ApplicationController
  def show
    @job = Jobler::Job.find_by!(slug: params[:id])

    respond_to do |format|
      format.json do
        render json: {job: job_payload}
      end

      if @job.completed?
        @job.jobler.controller = self
        @job.jobler.format = format

        @result = @job.jobler.result

        if @result.is_a?(Jobler::RedirectTo)
          format.html { redirect_to @result.url }
        else
          format.html
        end
      else
        format.html
      end
    end
  end

private

  def job_payload
    payload = {
      headline: @job.status_title.presence || @job.state.humanize,
      progress: @job.progress,
      state: @job.state,
      state_humanized: @job.state.humanize,
      status_title: @job.status_title
    }

    if @job.progress_counts_available?
      payload[:progress_current_count] = @job.progress_current_count
      payload[:progress_total_count] = @job.progress_total_count
    end

    payload
  end
end
