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

      @job.update!(ended_at: Time.zone.now, progress: 1.0, state: "completed")
    rescue Exception => e # rubocop:disable Lint/RescueException
      @job.update!(
        ended_at: Time.zone.now,
        error_message: e.message,
        error_type: e.class.name,
        error_backtrace: e.backtrace.join("\n"),
        state: "error"
      )
    end
  end

private

  def with_locale(&blk)
    if @job.locale?
      I18n.with_locale(@job.locale, &blk)
    else
      yield
    end
  end
end
