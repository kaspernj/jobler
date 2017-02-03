class Jobler::BaseJobler
  attr_reader :args, :job

  def create_result!(args)
    temp_file = args.fetch(:temp_file)
    temp_file.close unless temp_file.closed?

    job.results.create!(
      name: args.fetch(:name),
      result: File.read(temp_file.path)
    )
  end

  def execute!
    raise NoMethodError, "You should define the 'execute!' method on #{self.class.name}"
  end

  def increment_progress!
    @_progress_count ||= 0.0
    @_progress_count += 1.0

    new_progress = @_progress_count / @_progress_total

    if @_current_progress.nil?
      update = true
    else
      progress_difference = new_progress - @_current_progress
      update = true if progress_difference > 0.01
    end

    if update
      job.update_attributes!(progress: new_progress)
      @_current_progress = new_progress
    end
  end

  def progress_total(new_total)
    @_progress_total = new_total.to_f
  end

  def result
    raise NoMethodError, "You should define the 'result' method on #{self.class.name}"
  end

  def temp_file_for_result(args)
    job_result = job.results.where(name: args.fetch(:name)).first

    raise "No result by that name: #{args.fetch(:name)}" unless job_result

    temp_file = Tempfile.new
    temp_file.binmode
    temp_file.write(job_result.result)
    temp_file.close
    temp_file
  end
end
