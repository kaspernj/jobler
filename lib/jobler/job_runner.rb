class Jobler::JobRunner < ActiveJob::Base
  queue_as :jobler

  def perform(job_id)
    job = Jobler::Job.find(job_id)
    job.update_attributes!(started_at: Time.zone.now, state: "started")

    begin
      job.jobler.execute!
      job.update_attributes!(ended_at: Time.zone.now, progress: 1.0, state: "completed")
    rescue Exception => e # rubocop:disable Lint/RescueException
      job.update_attributes!(ended_at: Time.zone.now, state: "error")
      raise e
    end
  end
end
