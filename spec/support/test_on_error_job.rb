class TestOnErrorJobler < Jobler::BaseJobler
  on_error do |error|
    job.update!(status_title: "#{error.class.name}: #{error.message}: #{job.state}: #{job.error_type}")
  end

  # This method will be executed in the background
  def execute!
    raise ArgumentError, "on error callback"
  end
end
