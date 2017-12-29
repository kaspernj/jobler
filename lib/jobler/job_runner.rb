class Jobler::JobRunner < ActiveJob::Base # rubocop:disable Rails/ApplicationJob
  queue_as :jobler

  def perform(job_id)
    @job = Jobler::Job.find(job_id)
    @job.update_attributes!(started_at: Time.zone.now, state: "started")

    begin
      with_locale do
        @job.jobler.execute!
      end

      @job.update_attributes!(ended_at: Time.zone.now, progress: 1.0, state: "completed")
    rescue Exception => e # rubocop:disable Lint/RescueException
      @job.update_attributes!(
        ended_at: Time.zone.now,
        error_message: e.message,
        error_type: e.class.name,
        error_backtrace: e.backtrace.join("\n"),
        state: "error"
      )
    end
  end

private

  def with_locale
    if @job.locale?
      I18n.with_locale(@job.locale) do
        yield
      end
    else
      yield
    end
  end
end
