class Jobler::BaseJobler
  # Progress is written at most once per this fraction of the job, so a jobler that
  # increments once per record does not write - and broadcast - once per record.
  PROGRESS_WRITE_MINIMUM_DIFFERENCE = 0.01

  # Without a declared total there is no fraction to throttle on, so the counts
  # fall back to this interval instead.
  COUNTS_WRITE_MINIMUM_INTERVAL_SECONDS = 1.0

  attr_accessor :controller, :format
  attr_reader :args, :job

  def self.before_jobling(&blk)
    @@before_jobling ||= [] # rubocop:disable Style/ClassVars
    @@before_jobling << blk
  end

  def self.after_jobling(&blk)
    @@after_jobling ||= [] # rubocop:disable Style/ClassVars
    @@after_jobling << blk
  end

  def self.on_error(&blk)
    @@on_error ||= [] # rubocop:disable Style/ClassVars
    @@on_error << blk
  end

  def initialize(args:, job:)
    @args = args
    @job = job
    @_status_title = job.status_title if job.has_attribute?(:status_title)

    @@before_jobling ||= [] # rubocop:disable Style/ClassVars
    @@after_jobling ||= [] # rubocop:disable Style/ClassVars
  end

  def call_before_callbacks
    @@before_jobling&.each do |before_callback|
      instance_eval(&before_callback)
    end
  end

  def call_after_callbacks
    @@after_jobling&.each do |after_callback|
      instance_eval(&after_callback)
    end
  end

  def call_error_callbacks(error)
    @@on_error&.each do |error_callback|
      instance_exec(error, &error_callback)
    end
  end

  def create_result!(content: nil, name:, result: nil, temp_file: nil, save_in_database: false)
    jobler_result = job.results.new(name: name)

    if content && !temp_file
      temp_file = Tempfile.new(name)
      temp_file.write(content)
      temp_file.close
    end

    if result
      jobler_result.result = result
    else
      raise "No tempfile could be found" unless temp_file

      handle_file(jobler_result: jobler_result, save_in_database: save_in_database, temp_file: temp_file)
    end

    jobler_result.save!
    jobler_result
  end

  def execute!
    raise NoMethodError, "You should define the 'execute!' method on #{self.class.name}"
  end

  def jobler_name
    new_name = ""

    parts = self.class.name.split("::")
    parts.each do |part|
      new_name << "/" unless new_name.empty?
      new_name << part.underscore
    end

    new_name
  end

  # Counts one finished step. Safe to call before any total is declared: until a
  # total arrives the job reports raw counts and no fraction.
  def increment_progress!(value: 1.0)
    @_progress_count = @_progress_count.to_f + value.to_f
    @_progress_steps = @_progress_steps.to_i + value.to_i

    _update_progress(force: false)
  end

  # Declares how many steps the job is about to run, which is what turns a bare
  # percentage into "37 of 214". Can be called after some steps have already been
  # counted, as long as the total is only known once the work has started.
  def progress_total(new_total = nil)
    @_progress_total = new_total&.to_f
    @_progress_last_written = nil

    _update_progress(force: true)
  end

  def render(template_path, locals = {})
    template_path = "joblers/#{jobler_name}/#{template_path}" if template_path.is_a?(Symbol)

    request = ActionDispatch::Request.new(
      "HTTP_HOST" => "#{job.host}:#{job.port}",
      "HTTP_X_FORWARDED_PROTO" => job.protocol
    )

    controller = ::ApplicationJoblerController.new
    controller.instance_variable_set(:@jobler, self)
    controller.request = request
    controller.response = ActionDispatch::Response.new

    render_result = controller.render_to_string(template_path, layout: false, locals: {jobler: self}.merge(locals))

    if render_result.is_a?(String)
      # Rails 5 behaviour
      render_result
    else
      # Rails 4 behaviour
      render_result.join
    end
  end

  def result
    raise NoMethodError, "You should define the 'result' method on #{self.class.name}"
  end

  # Tells the user where the job currently is. Text that is identical to what is
  # already stored is not written again, so a jobler can report the same status for
  # every record without that becoming one database write and one broadcast each.
  def status_title!(value)
    unless job.has_attribute?(:status_title)
      raise "Jobler::Job has no 'status_title' column, so status text cannot be stored. " \
            "Install the Jobler migration 20260219090000_add_status_title_to_jobler_jobs."
    end

    new_value = value.to_s
    new_value = nil if new_value.empty?

    return if new_value == @_status_title

    job.update!(status_title: new_value)
    @_status_title = new_value
  end

  def temp_file_for_result(name:)
    job_result = job.results.where(name: name).first
    raise "No result by that name: #{name}" unless job_result

    temp_file = ::Tempfile.new("jobler_tempfile")
    temp_file.binmode
    temp_file.write(job_result.result)
    temp_file.close
    temp_file
  end

  def url_for_result(name:)
    job_result = job.results.where(name: name).first
    raise "No result by that name: #{name}" unless job_result

    Rails.application.routes.url_helpers.rails_blob_path(job_result.file.attachment, only_path: true)
  end

private

  def _counts_write?
    return true if @_progress_last_written_at.nil?

    (Time.zone.now - @_progress_last_written_at) >= COUNTS_WRITE_MINIMUM_INTERVAL_SECONDS
  end

  def _progress_fraction(total)
    return nil if total.nil? || total.zero?

    progress = @_progress_count.to_f / total
    [progress, 1.0].min
  end

  def _progress_write?(progress, force:)
    return true if force
    return _counts_write? if progress.nil?

    # Reaching the end is always written: without this the last step falls inside
    # the throttle and a finished job is left stored at 999 of 1000.
    return true if progress >= 1.0
    return true if @_progress_last_written.nil?

    (progress - @_progress_last_written) > PROGRESS_WRITE_MINIMUM_DIFFERENCE
  end

  def _progress_attributes(total, progress)
    attributes = {progress_current_count: @_progress_steps.to_i}
    attributes[:progress] = progress if progress
    attributes[:progress_total_count] = total.to_i if total

    # An app that has not installed 20261126090000 yet keeps reporting progress, just without counts.
    attributes.select { |name, _value| job.has_attribute?(name) }
  end

  def _update_progress(force:)
    total = @_progress_total
    progress = _progress_fraction(total)

    return unless _progress_write?(progress, force: force)

    job.update!(_progress_attributes(total, progress))
    @_progress_last_written = progress
    @_progress_last_written_at = Time.zone.now
  end

  def handle_file(jobler_result:, save_in_database:, temp_file:)
    if save_in_database
      temp_file.close unless temp_file.closed?
      content = File.read(temp_file.path)
      jobler_result.result = content
    else
      jobler_result.file.attach(
        filename: File.basename(temp_file.path),
        io: File.open(temp_file.path)
      )
    end
  end
end
