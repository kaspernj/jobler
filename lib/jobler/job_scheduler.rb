class Jobler::JobScheduler
  attr_reader :job

  def self.create!(args)
    scheduler = Jobler::JobScheduler.new(args)
    scheduler.create_job
    scheduler.perform_job_later
    scheduler
  end

  def initialize(args)
    @jobler_type = args.fetch(:jobler_type)
    @job_args = args[:job_args]
    @locale = args[:locale]
  end

  def create_job
    @job = Jobler::Job.create!(
      jobler_type: @jobler_type,
      locale: @locale.presence || I18n.locale,
      parameters: YAML.dump(@job_args)
    )
  end

  def perform_job_later
    Jobler::JobRunner.perform_later(job.id)
  end
end
