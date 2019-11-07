class Jobler::BaseJobler
  attr_accessor :controller, :format
  attr_reader :args, :job

  def initialize(args = {})
    @args = args[:args]
    @job = args[:job]
  end

  def create_result!(args)
    if args[:temp_file]
      temp_file = args.fetch(:temp_file)
      temp_file.close unless temp_file.closed?
      content = File.read(temp_file.path)
    else
      content = args.fetch(:content)
    end

    job.results.create!(
      name: args.fetch(:name),
      result: content
    )
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

  def increment_progress!(value: 1.0)
    @_progress_count ||= 0.0
    @_progress_count += value.to_f

    new_progress = @_progress_count / @_progress_total

    if @_current_progress.nil?
      update = true
    else
      progress_difference = new_progress - @_current_progress
      update = true if progress_difference > 0.01
    end

    if update
      job.update!(progress: new_progress)
      @_current_progress = new_progress
    end
  end

  def progress_total(new_total)
    @_progress_total = new_total.to_f
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

    render_result = controller.render(template_path, formats: Mime::EXTENSION_LOOKUP.keys, layout: false, locals: {jobler: self}.merge(locals))

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

  def temp_file_for_result(args)
    job_result = job.results.where(name: args.fetch(:name)).first

    raise "No result by that name: #{args.fetch(:name)}" unless job_result

    temp_file = ::Tempfile.new("jobler_tempfile")
    temp_file.binmode
    temp_file.write(job_result.result)
    temp_file.close
    temp_file
  end
end
