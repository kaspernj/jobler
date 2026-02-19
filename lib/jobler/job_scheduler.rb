class Jobler::JobScheduler
  attr_reader :job

  def self.create!(args)
    scheduler = Jobler::JobScheduler.new(args)
    scheduler.create_job
    scheduler.perform_job_later
    scheduler
  end

  def initialize(args)
    @controller = args[:controller]
    @jobler_type = args.fetch(:jobler_type)
    @job_args = args[:job_args]
    @locale = args[:locale]
    @status_title = args[:status_title]
  end

  def create_job
    @job = Jobler::Job.new(
      jobler_type: @jobler_type,
      locale: @locale.presence || I18n.locale,
      parameters: YAML.dump(@job_args),
      status_title: @status_title
    )

    if @controller
      @job.assign_attributes(
        host: @controller.request.host,
        port: @controller.request.port,
        protocol: @controller.request.protocol
      )
    end

    @job.save!
  end

  def perform_job_later
    Jobler::JobRunner.perform_later(job.id)
  end
end
