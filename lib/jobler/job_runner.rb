class Jobler::JobRunner < ActiveJob::Base # rubocop:disable Rails/ApplicationJob
  queue_as :jobler

  def perform(job_id)
    @job = Jobler::Job.find(job_id)
    @job.update!(started_at: Time.zone.now, state: "started")

    begin
      with_locale do
        @job.jobler.call_before_callbacks

        begin
          @job.jobler.execute!
        ensure
          @job.jobler.call_after_callbacks
        end
      end

      complete_job
    rescue Exception => e # rubocop:disable Lint/RescueException
      fail_job(e)
    end
  end

private

  def complete_job
    completion_attributes = {ended_at: Time.zone.now, progress: 1.0, state: "completed"}

    # A finished job has run every step it declared, so the counts are closed out
    # rather than left at whatever the last throttled write happened to store.
    completion_attributes[:progress_current_count] = @job.progress_total_count if jobler_declared_steps?

    @job.update!(completion_attributes)
  end

  def fail_job(error)
    @job.update!(
      ended_at: Time.zone.now,
      error_backtrace: error.backtrace.join("\n"),
      error_message: error.message,
      error_type: error.class.name,
      state: "error"
    )

    @job.jobler.call_error_callbacks(error)
  end

  def jobler_declared_steps?
    @job.progress_counts_available? && @job.progress_total_count.to_i.positive?
  end

  def with_locale(&blk)
    if @job.locale?
      I18n.with_locale(@job.locale, &blk)
    else
      yield
    end
  end
end
